import { TypedDataToPrimitiveTypes } from 'abitype'

import { GetContractReturnType, TypedDataDefinition, WalletClient } from 'viem'

import { Plug } from '@/src/core/plug'

import { PLUGS_TYPES } from '@nftchance/plug-types'

export class PlugSDK<
	TClient extends WalletClient = WalletClient,
	TDomain extends
		TypedDataDefinition['domain'] = TypedDataDefinition['domain'],
	TMessage extends TypedDataToPrimitiveTypes<
		typeof PLUGS_TYPES
	>['Plugs'] = TypedDataToPrimitiveTypes<typeof PLUGS_TYPES>['Plugs']
> {
	public plugs: Plug[] = []

	build(
		domain: TDomain,
		contract: GetContractReturnType | `0x${string}`,
		message: TMessage
	): Plug<TClient> {
		const plug = new Plug<TClient>(
			{
				...domain,
				verifyingContract:
					typeof contract === 'string' ? contract : contract.address
			},
			message
		)

		this.plugs.push(plug)

		return plug
	}

	latest() {
		if (this.plugs.length == 0) return undefined

		return this.plugs[this.plugs.length - 1]
	}
}
