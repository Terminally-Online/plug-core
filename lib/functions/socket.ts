import { default as cliProgress } from 'cli-progress'
import dotenv from 'dotenv'
import { execa, execaSync } from 'execa'
import { existsSync, default as fs, readJsonSync } from 'fs-extra'

import { version } from '../../package.json'

dotenv.config()

const bar = new cliProgress.SingleBar({}, cliProgress.Presets.shades_classic)

const initcodeJson = readJsonSync(
	'./artifacts/Plug.Router.sol/PlugRouter.initcode.json'
)

const initcode = initcodeJson.initcode
const initcodeHash = initcodeJson.initcodeHash

const caller =
	process.env.PLUG_CREATE2_CALLER ||
	'0x0000000000000000000000000000000000000000'

if (process.env.PLUG_CREATE2_CACHE !== 'true')
	if (existsSync('./create2crunch')) fs.removeSync('./create2crunch')

if (!existsSync('./create2crunch'))
	execaSync('git', ['clone', 'https://github.com/0age/create2crunch'])

const seconds = parseInt(process.env.PLUG_CREATE2_MINING_DURATION || '60')
console.log(`
   ◍ Plug Socket Crunching ${version}
   - Duration: ${seconds} seconds
   - Environments: .env
`)
bar.start(seconds, 0)

const child = execa(
	'cargo',
	[
		'run',
		'--release',
		'0x0000000000FFe8B47B3e2130213B802212439497',
		caller,
		initcodeHash
	],
	{ cwd: './create2crunch' }
)

let interval = setInterval(() => {
	bar.increment(1)
}, 1000)

setTimeout(() => {
	clearInterval(interval)
	bar.stop()
	child.kill()

	const efficientAddressesTxt = fs
		.readFileSync('./create2crunch/efficient_addresses.txt', 'utf8')
		.split('\n')

	let crunched: (string | number)[] | undefined = undefined
	for (let i = 0; i < efficientAddressesTxt.length; i++) {
		const line = efficientAddressesTxt[i]
		let [salt, _address, rarity] = line.split(' => ')
		const rarityNum = parseInt(rarity)

		const leadingZeroes = salt.match(/^0+/)?.[0].length || 0
		const leadingZeroesOnCrunched =
			(crunched?.[0] as string)?.match(/^0+/)?.[0].length || 0

		const higherRareness = rarity > (crunched?.[2] || 0)
		const higherLeadingZeroes = leadingZeroes > leadingZeroesOnCrunched

		if (crunched === undefined) {
			crunched = [salt, _address, rarityNum]
		} else if (higherRareness) {
			crunched = [salt, _address, rarityNum]
		} else if (higherLeadingZeroes) {
			crunched = [salt, _address, rarityNum]
		}
	}

	const salt = crunched![0]
	const address = crunched![1]

	console.log(`
   ◍ Plug Socket Crunched ${version}
   - Crunched: ${efficientAddressesTxt.length}
   - Salt: ${salt}
   - Address: ${address}
   - Rarity: ${crunched![2]}`)

	if (process.env.PLUG_CREATE2_CACHE !== 'true')
		fs.removeSync('./create2crunch')

	const etcher = `// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import { PlugRouter } from "./Plug.Router.sol";
import { PlugSocketLib } from "../abstracts/Plug.Socket.sol";

/**
 * @title Plug Router Etcher
 * @notice Etch the contract into the forge vm via create2 for test-only purposes.
 * @dev Under no circumstances should you ever use this outside of testing.
 * @author nftchance (chance@utc24.io)
 * @author vectorized.eth (https://github.com/Vectorized/multicaller/blob/main/src/MulticallerEtcher.sol)
 */
library PlugRouterEtcher {
    bytes internal constant PLUG_ROUTER_INITCODE =
        hex"${initcode}";
    bytes32 internal constant PLUG_ROUTER_CREATE2_SALT =
        ${salt};

    /**
     * @dev Deploys the Router and returns the accessible interface reference.
     */
    function router() internal returns (PlugRouter deployment) {
        address expectedDeployment = PlugSocketLib.PLUG_ROUTER;
        if (_extcodesize(expectedDeployment) == 0) {
            bytes32 salt = PLUG_ROUTER_CREATE2_SALT;
            address d = _safeCreate2(salt, PLUG_ROUTER_INITCODE);
            require(d == expectedDeployment, "Unable to etch PlugRouter.");
            deployment = PlugRouter(payable(d));
        }
    }

    /**
     * @dev Deploys a contract via 0age's immutable create 2 factory for testing.
     */
    function _safeCreate2(bytes32 salt, bytes memory initializationCode) private returns (address deployment) {
        // Canonical address of 0age's immutable create 2 factory.
        address c2f = 0x0000000000FFe8B47B3e2130213B802212439497;
        if (_extcodesize(c2f) == 0) {
            bytes memory ic2fBytecode =
                hex"60806040526004361061003f5760003560e01c806308508b8f1461004457806364e030871461009857806385cf97ab14610138578063a49a7c90146101bc575b600080fd5b34801561005057600080fd5b506100846004803603602081101561006757600080fd5b503573ffffffffffffffffffffffffffffffffffffffff166101ec565b604080519115158252519081900360200190f35b61010f600480360360408110156100ae57600080fd5b813591908101906040810160208201356401000000008111156100d057600080fd5b8201836020820111156100e257600080fd5b8035906020019184600183028401116401000000008311171561010457600080fd5b509092509050610217565b6040805173ffffffffffffffffffffffffffffffffffffffff9092168252519081900360200190f35b34801561014457600080fd5b5061010f6004803603604081101561015b57600080fd5b8135919081019060408101602082013564010000000081111561017d57600080fd5b82018360208201111561018f57600080fd5b803590602001918460018302840111640100000000831117156101b157600080fd5b509092509050610592565b3480156101c857600080fd5b5061010f600480360360408110156101df57600080fd5b508035906020013561069e565b73ffffffffffffffffffffffffffffffffffffffff1660009081526020819052604090205460ff1690565b600083606081901c33148061024c57507fffffffffffffffffffffffffffffffffffffffff0000000000000000000000008116155b6102a1576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260458152602001806107746045913960600191505060405180910390fd5b606084848080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920182905250604051855195965090943094508b93508692506020918201918291908401908083835b6020831061033557805182527fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe090920191602091820191016102f8565b51815160209384036101000a7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff018019909216911617905260408051929094018281037fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe00183528085528251928201929092207fff000000000000000000000000000000000000000000000000000000000000008383015260609890981b7fffffffffffffffffffffffffffffffffffffffff00000000000000000000000016602183015260358201969096526055808201979097528251808203909701875260750182525084519484019490942073ffffffffffffffffffffffffffffffffffffffff81166000908152938490529390922054929350505060ff16156104a7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252603f815260200180610735603f913960400191505060405180910390fd5b81602001825188818334f5955050508073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161461053a576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260468152602001806107b96046913960600191505060405180910390fd5b50505073ffffffffffffffffffffffffffffffffffffffff8116600090815260208190526040902080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660011790559392505050565b6000308484846040516020018083838082843760408051919093018181037fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe001825280845281516020928301207fff000000000000000000000000000000000000000000000000000000000000008383015260609990991b7fffffffffffffffffffffffffffffffffffffffff000000000000000000000000166021820152603581019790975260558088019890985282518088039098018852607590960182525085519585019590952073ffffffffffffffffffffffffffffffffffffffff81166000908152948590529490932054939450505060ff909116159050610697575060005b9392505050565b604080517fff000000000000000000000000000000000000000000000000000000000000006020808301919091523060601b6021830152603582018590526055808301859052835180840390910181526075909201835281519181019190912073ffffffffffffffffffffffffffffffffffffffff81166000908152918290529190205460ff161561072e575060005b9291505056fe496e76616c696420636f6e7472616374206372656174696f6e202d20636f6e74726163742068617320616c7265616479206265656e206465706c6f7965642e496e76616c69642073616c74202d206669727374203230206279746573206f66207468652073616c74206d757374206d617463682063616c6c696e6720616464726573732e4661696c656420746f206465706c6f7920636f6e7472616374207573696e672070726f76696465642073616c7420616e6420696e697469616c697a6174696f6e20636f64652ea265627a7a723058202bdc55310d97c4088f18acf04253db593f0914059f0c781a9df3624dcef0d1cf64736f6c634300050a0032";
            /// @solidity memory-safe-assembly
            assembly {
                let m := mload(0x40)
                mstore(m, 0xb4d6c782) // 'etch(address,bytes)'.
                mstore(add(m, 0x20), c2f)
                mstore(add(m, 0x40), 0x40)
                let n := mload(ic2fBytecode)
                mstore(add(m, 0x60), n)
                for { let i := 0 } lt(i, n) { i := add(0x20, i) } {
                    mstore(add(add(m, 0x80), i), mload(add(add(ic2fBytecode, 0x20), i)))
                }
                let vmAddress := 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
                if iszero(call(gas(), vmAddress, 0, add(m, 0x1c), add(n, 0x64), 0x00, 0x00)) { revert(0, 0) }
            }
        }
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40)
            let n := mload(initializationCode)
            mstore(m, 0x64e03087) // 'safeCreate2(bytes32,bytes)'.
            mstore(add(m, 0x20), salt)
            mstore(add(m, 0x40), 0x40)
            mstore(add(m, 0x60), n)
            // prettier-ignore
            for { let i := 0 } lt(i, n) { i := add(i, 0x20) } {
                mstore(add(add(m, 0x80), i), mload(add(add(initializationCode, 0x20), i)))
            }
            if iszero(call(gas(), c2f, 0, add(m, 0x1c), add(n, 0x64), m, 0x20)) {
                returndatacopy(m, m, returndatasize())
                revert(m, returndatasize())
            }
            deployment := mload(m)
        }
    }

    /**
     * @dev Returns the extcodesize of 'deployment'.
     */
    function _extcodesize(address deployment) private view returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := extcodesize(deployment)
        }
    }
}`

	fs.writeFileSync('./src/contracts/routers/Plug.Router.Etcher.sol', etcher)

	const socket = `// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

library PlugSocketLib {
    address internal constant PLUG_ROUTER = ${address};
}

/**
 * @title Plug Socket
 * @notice The socket contract of Plug enables the ability to utilize the forwarded sender/signer
 *         from a call bundle that may have originated from a Plug Router.
 * @author nftchance (chance@utc24.io)
 **/
abstract contract PlugSocket {
    address internal constant PLUG_ROUTER = ${address};

    function _msgSender() internal view returns (address $signer) {
        assembly {
            mstore(0x00, caller())
            let withSender := PLUG_ROUTER
            if eq(caller(), withSender) {
                let success := staticcall(gas(), withSender, 0x00, 0x00, 0x20, 0x20)
                if iszero(success) { revert(codesize(), codesize()) }
                $signer := mload(0x20)
            }
        }
    }
}`

	fs.writeFileSync('./src/contracts/abstracts/Plug.Socket.sol', socket)
}, seconds * 1000)

child.on('exit', () => {
	clearInterval(interval)
	bar.stop()
})
