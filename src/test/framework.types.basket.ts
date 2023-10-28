import hre from 'hardhat'

import { Framework } from '@/framework'

const RUN = false

export default async function () {
	if (!RUN) throw new Error('This test is not meant to be run.')

	const [name, version] = ['FrameworkMock', '0.0.0']

	const DEBUG_TYPES = {
		Mail: [
			{ name: 'from', type: 'Person' },
			{ name: 'to', type: 'Person' },
			{ name: 'contents', type: 'string' }
		],
		Person: [
			{ name: 'name', type: 'string' },
			{ name: 'wallet', type: 'address' }
		],
		Email: [
			{ name: 'from', type: 'Person' },
			{ name: 'to', type: 'Person[]' },
			{ name: 'mail', type: 'SignedMail[]' }
		],
		SignedMail: [
			{ name: 'mail', type: 'Mail' },
			{ name: 'signature', type: 'bytes' }
		],
		SignedEmail: [
			{ name: 'email', type: 'Email' },
			{ name: 'signature', type: 'bytes' }
		]
	} as const

	const contract = await hre.viem.deployContract(name)
	const [owner] = await hre.viem.getWalletClients()

	// * Create the util with the debug types.
	const util = new Framework(name, version, 1, DEBUG_TYPES, contract)
	//    ^?

	// @ts-expect-error - SHOULD_FAIL is not a valid type.
	await util.sign(owner, 'SHOULD_FAIL', {
		name: 'Bob',
		wallet: owner.account.address
	})

	// * Can sign mail.
	const mail = await util.sign(owner, 'Mail', {
		from: { name: 'Bob', wallet: owner.account.address },
		to: { name: 'Alice', wallet: owner.account.address },
		contents: 'Hello, world!'
	})

	// * Cannot create an intent with fields that do not belong.
	await util.sign(owner, 'Mail', {
		from: { name: 'Bob', wallet: owner.account.address },
		to: { name: 'Alice', wallet: owner.account.address },
		contents: 'Hello, world!',
		// @ts-expect-error - Doesnt exist on Mail.
		mail: []
	})

	if (!mail.intent) throw new Error('Mail intent not initialized.')

	// * Can create another type that references the mail type.
	const email = await util.sign(owner, 'Email', {
		from: { name: 'Bob', wallet: owner.account.address },
		to: [
			{ name: 'Alice', wallet: owner.account.address },
			{ name: 'Charlie', wallet: owner.account.address }
		],
		mail: [mail.intent]
	})

	if (!mail.intent) throw new Error('Mail intent not initialized.')

	const Mail = mail.intent

	if (!email.intent) throw new Error('Email intent not initialized.')

	const Email = email.intent

	// * These should both work.
	Mail.mail.from
	Mail.signature

	Email.email
	Email.email.from
	Email.signature

	// * None of these should work.
	// @ts-expect-error - Doesnt exist.
	Mail.email
	// @ts-expect-error - Doesnt exist.
	Mail.Mail
	// @ts-expect-error - Doesnt exist.
	Mail.Email
}

type ShapeType<T extends keyof typeof OBJECT_SHAPES> = {
	signature: string
} & { [K in T]: (typeof OBJECT_SHAPES)[T] }

const OBJECT_SHAPES = {
	one: { name: 'one' },
	two: { number: 'two' },
	three: { name: 'three', number: 'three' }
} as const

function takeShape<T extends keyof typeof OBJECT_SHAPES>(
	shape: T
): ShapeType<T> {
	return {
		signature: '0x',
		[shape]: OBJECT_SHAPES[shape]
	} as ShapeType<T>
}

const shape = takeShape('three')
shape.three.name
shape.three.number
shape.signature