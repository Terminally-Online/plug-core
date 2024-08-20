import {
  createUseReadContract,
  createUseWriteContract,
  createUseSimulateContract,
  createUseWatchContractEvent,
} from 'wagmi/codegen'

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Plug
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const plugAbi = [
  {
    type: 'function',
    inputs: [],
    name: 'name',
    outputs: [{ name: '$name', internalType: 'string', type: 'string' }],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$livePlugs',
        internalType: 'struct PlugTypesLib.LivePlugs',
        type: 'tuple',
        components: [
          {
            name: 'plugs',
            internalType: 'struct PlugTypesLib.Plugs',
            type: 'tuple',
            components: [
              { name: 'socket', internalType: 'address', type: 'address' },
              {
                name: 'plugs',
                internalType: 'struct PlugTypesLib.Plug[]',
                type: 'tuple[]',
                components: [
                  { name: 'target', internalType: 'address', type: 'address' },
                  { name: 'value', internalType: 'uint256', type: 'uint256' },
                  { name: 'data', internalType: 'bytes', type: 'bytes' },
                ],
              },
              { name: 'solver', internalType: 'bytes', type: 'bytes' },
              { name: 'salt', internalType: 'bytes32', type: 'bytes32' },
            ],
          },
          { name: 'signature', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    name: 'plug',
    outputs: [
      {
        name: '$results',
        internalType: 'struct PlugTypesLib.Result[]',
        type: 'tuple[]',
        components: [
          { name: 'success', internalType: 'bool', type: 'bool' },
          { name: 'result', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$livePlugs',
        internalType: 'struct PlugTypesLib.LivePlugs[]',
        type: 'tuple[]',
        components: [
          {
            name: 'plugs',
            internalType: 'struct PlugTypesLib.Plugs',
            type: 'tuple',
            components: [
              { name: 'socket', internalType: 'address', type: 'address' },
              {
                name: 'plugs',
                internalType: 'struct PlugTypesLib.Plug[]',
                type: 'tuple[]',
                components: [
                  { name: 'target', internalType: 'address', type: 'address' },
                  { name: 'value', internalType: 'uint256', type: 'uint256' },
                  { name: 'data', internalType: 'bytes', type: 'bytes' },
                ],
              },
              { name: 'solver', internalType: 'bytes', type: 'bytes' },
              { name: 'salt', internalType: 'bytes32', type: 'bytes32' },
            ],
          },
          { name: 'signature', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    name: 'plug',
    outputs: [
      {
        name: '$results',
        internalType: 'struct PlugTypesLib.Result[][]',
        type: 'tuple[][]',
        components: [
          { name: 'success', internalType: 'bool', type: 'bool' },
          { name: 'result', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'symbol',
    outputs: [{ name: '$version', internalType: 'string', type: 'string' }],
    stateMutability: 'pure',
  },
  {
    type: 'error',
    inputs: [
      { name: '$intended', internalType: 'address', type: 'address' },
      { name: '$socket', internalType: 'address', type: 'address' },
    ],
    name: 'SocketAddressInvalid',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PlugFactory
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const plugFactoryAbi = [
  { type: 'constructor', inputs: [], stateMutability: 'nonpayable' },
  {
    type: 'function',
    inputs: [],
    name: 'cancelOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'pendingOwner', internalType: 'address', type: 'address' },
    ],
    name: 'completeOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [{ name: '$salt', internalType: 'bytes32', type: 'bytes32' }],
    name: 'deploy',
    outputs: [
      { name: '$alreadyDeployed', internalType: 'bool', type: 'bool' },
      { name: '$socket', internalType: 'address', type: 'address' },
    ],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$implementation', internalType: 'address', type: 'address' },
      { name: '$salt', internalType: 'bytes32', type: 'bytes32' },
    ],
    name: 'getAddress',
    outputs: [{ name: '$vault', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint16', type: 'uint16' }],
    name: 'implementations',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '$implementation', internalType: 'address', type: 'address' },
    ],
    name: 'initCodeHash',
    outputs: [
      { name: '$initCodeHash', internalType: 'bytes32', type: 'bytes32' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '$owner', internalType: 'address', type: 'address' },
      { name: '$baseURI', internalType: 'string', type: 'string' },
      { name: '$implementation', internalType: 'address', type: 'address' },
    ],
    name: 'initialize',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'owner',
    outputs: [{ name: 'result', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'pendingOwner', internalType: 'address', type: 'address' },
    ],
    name: 'ownershipHandoverExpiresAt',
    outputs: [{ name: 'result', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'renounceOwnership',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'requestOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$version', internalType: 'uint16', type: 'uint16' },
      { name: '$implementation', internalType: 'address', type: 'address' },
    ],
    name: 'setImplementation',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: 'newOwner', internalType: 'address', type: 'address' }],
    name: 'transferOwnership',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'pendingOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipHandoverCanceled',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'pendingOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipHandoverRequested',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'oldOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'newOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipTransferred',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'implementation',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'vault',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'salt',
        internalType: 'bytes32',
        type: 'bytes32',
        indexed: false,
      },
    ],
    name: 'SocketDeployed',
  },
  { type: 'error', inputs: [], name: 'AlreadyInitialized' },
  {
    type: 'error',
    inputs: [{ name: '$version', internalType: 'uint16', type: 'uint16' }],
    name: 'ImplementationAlreadyInitialized',
  },
  {
    type: 'error',
    inputs: [{ name: '$version', internalType: 'uint16', type: 'uint16' }],
    name: 'ImplementationInvalid',
  },
  { type: 'error', inputs: [], name: 'NewOwnerIsZeroAddress' },
  { type: 'error', inputs: [], name: 'NoHandoverRequest' },
  { type: 'error', inputs: [], name: 'Unauthorized' },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PlugTreasury
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const plugTreasuryAbi = [
  { type: 'fallback', stateMutability: 'payable' },
  { type: 'receive', stateMutability: 'payable' },
  {
    type: 'function',
    inputs: [],
    name: 'cancelOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'pendingOwner', internalType: 'address', type: 'address' },
    ],
    name: 'completeOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$targets', internalType: 'address[]', type: 'address[]' },
      { name: '$values', internalType: 'uint256[]', type: 'uint256[]' },
      { name: '$datas', internalType: 'bytes[]', type: 'bytes[]' },
    ],
    name: 'execute',
    outputs: [
      { name: '$successes', internalType: 'bool[]', type: 'bool[]' },
      { name: '$results', internalType: 'bytes[]', type: 'bytes[]' },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '$owner', internalType: 'address', type: 'address' }],
    name: 'initialize',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'owner',
    outputs: [{ name: 'result', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'pendingOwner', internalType: 'address', type: 'address' },
    ],
    name: 'ownershipHandoverExpiresAt',
    outputs: [{ name: 'result', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '$target', internalType: 'address payable', type: 'address' },
      { name: '$data', internalType: 'bytes', type: 'bytes' },
      { name: '$fee', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'plugNative',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$tokenIn', internalType: 'address', type: 'address' },
      { name: '$target', internalType: 'address payable', type: 'address' },
      { name: '$data', internalType: 'bytes', type: 'bytes' },
      { name: '$fee', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'plugNativeToToken',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$tokenOut', internalType: 'address', type: 'address' },
      { name: '$target', internalType: 'address payable', type: 'address' },
      { name: '$data', internalType: 'bytes', type: 'bytes' },
      { name: '$sell', internalType: 'uint256', type: 'uint256' },
      { name: '$fee', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'plugToken',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$tokenOut', internalType: 'address', type: 'address' },
      { name: '$target', internalType: 'address payable', type: 'address' },
      { name: '$data', internalType: 'bytes', type: 'bytes' },
      { name: '$sell', internalType: 'uint256', type: 'uint256' },
      { name: '$fee', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'plugTokenToNative',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$tokenOut', internalType: 'address', type: 'address' },
      { name: '$tokenIn', internalType: 'address', type: 'address' },
      { name: '$target', internalType: 'address payable', type: 'address' },
      { name: '$data', internalType: 'bytes', type: 'bytes' },
      { name: '$sell', internalType: 'uint256', type: 'uint256' },
      { name: '$fee', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'plugTokenToToken',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'renounceOwnership',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'requestOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: '$targets', internalType: 'address[]', type: 'address[]' },
      { name: '$allowed', internalType: 'bool', type: 'bool' },
    ],
    name: 'setTargetsAllowed',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'address', type: 'address' }],
    name: 'targetToAllowed',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: 'newOwner', internalType: 'address', type: 'address' }],
    name: 'transferOwnership',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'pendingOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipHandoverCanceled',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'pendingOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipHandoverRequested',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'oldOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'newOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipTransferred',
  },
  { type: 'error', inputs: [], name: 'AlreadyInitialized' },
  { type: 'error', inputs: [], name: 'NewOwnerIsZeroAddress' },
  { type: 'error', inputs: [], name: 'NoHandoverRequest' },
  { type: 'error', inputs: [], name: 'PlugFailed' },
  { type: 'error', inputs: [], name: 'Reentrancy' },
  { type: 'error', inputs: [], name: 'TargetInvalid' },
  { type: 'error', inputs: [], name: 'TokenAllowanceInvalid' },
  { type: 'error', inputs: [], name: 'TokenBalanceInvalid' },
  { type: 'error', inputs: [], name: 'Unauthorized' },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PlugVaultSocket
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const plugVaultSocketAbi = [
  { type: 'constructor', inputs: [], stateMutability: 'nonpayable' },
  { type: 'fallback', stateMutability: 'payable' },
  { type: 'receive', stateMutability: 'payable' },
  {
    type: 'function',
    inputs: [],
    name: 'cancelOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'pendingOwner', internalType: 'address', type: 'address' },
    ],
    name: 'completeOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$input',
        internalType: 'struct PlugTypesLib.EIP712Domain',
        type: 'tuple',
        components: [
          { name: 'name', internalType: 'string', type: 'string' },
          { name: 'version', internalType: 'string', type: 'string' },
          { name: 'chainId', internalType: 'uint256', type: 'uint256' },
          {
            name: 'verifyingContract',
            internalType: 'address',
            type: 'address',
          },
        ],
      },
    ],
    name: 'getEIP712DomainHash',
    outputs: [{ name: '$hash', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$input',
        internalType: 'struct PlugTypesLib.LivePlugs',
        type: 'tuple',
        components: [
          {
            name: 'plugs',
            internalType: 'struct PlugTypesLib.Plugs',
            type: 'tuple',
            components: [
              { name: 'socket', internalType: 'address', type: 'address' },
              {
                name: 'plugs',
                internalType: 'struct PlugTypesLib.Plug[]',
                type: 'tuple[]',
                components: [
                  { name: 'target', internalType: 'address', type: 'address' },
                  { name: 'value', internalType: 'uint256', type: 'uint256' },
                  { name: 'data', internalType: 'bytes', type: 'bytes' },
                ],
              },
              { name: 'solver', internalType: 'bytes', type: 'bytes' },
              { name: 'salt', internalType: 'bytes32', type: 'bytes32' },
            ],
          },
          { name: 'signature', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    name: 'getLivePlugsHash',
    outputs: [{ name: '$hash', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$input',
        internalType: 'struct PlugTypesLib.Plug[]',
        type: 'tuple[]',
        components: [
          { name: 'target', internalType: 'address', type: 'address' },
          { name: 'value', internalType: 'uint256', type: 'uint256' },
          { name: 'data', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    name: 'getPlugArrayHash',
    outputs: [{ name: '$hash', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$input',
        internalType: 'struct PlugTypesLib.Plug',
        type: 'tuple',
        components: [
          { name: 'target', internalType: 'address', type: 'address' },
          { name: 'value', internalType: 'uint256', type: 'uint256' },
          { name: 'data', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    name: 'getPlugHash',
    outputs: [{ name: '$hash', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$input',
        internalType: 'struct PlugTypesLib.Plugs',
        type: 'tuple',
        components: [
          { name: 'socket', internalType: 'address', type: 'address' },
          {
            name: 'plugs',
            internalType: 'struct PlugTypesLib.Plug[]',
            type: 'tuple[]',
            components: [
              { name: 'target', internalType: 'address', type: 'address' },
              { name: 'value', internalType: 'uint256', type: 'uint256' },
              { name: 'data', internalType: 'bytes', type: 'bytes' },
            ],
          },
          { name: 'solver', internalType: 'bytes', type: 'bytes' },
          { name: 'salt', internalType: 'bytes32', type: 'bytes32' },
        ],
      },
    ],
    name: 'getPlugsHash',
    outputs: [{ name: '$hash', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    inputs: [{ name: '$owner', internalType: 'address', type: 'address' }],
    name: 'initialize',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'name',
    outputs: [{ name: '$name', internalType: 'string', type: 'string' }],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    inputs: [],
    name: 'owner',
    outputs: [{ name: 'result', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'pendingOwner', internalType: 'address', type: 'address' },
    ],
    name: 'ownershipHandoverExpiresAt',
    outputs: [{ name: 'result', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$livePlugs',
        internalType: 'struct PlugTypesLib.LivePlugs',
        type: 'tuple',
        components: [
          {
            name: 'plugs',
            internalType: 'struct PlugTypesLib.Plugs',
            type: 'tuple',
            components: [
              { name: 'socket', internalType: 'address', type: 'address' },
              {
                name: 'plugs',
                internalType: 'struct PlugTypesLib.Plug[]',
                type: 'tuple[]',
                components: [
                  { name: 'target', internalType: 'address', type: 'address' },
                  { name: 'value', internalType: 'uint256', type: 'uint256' },
                  { name: 'data', internalType: 'bytes', type: 'bytes' },
                ],
              },
              { name: 'solver', internalType: 'bytes', type: 'bytes' },
              { name: 'salt', internalType: 'bytes32', type: 'bytes32' },
            ],
          },
          { name: 'signature', internalType: 'bytes', type: 'bytes' },
        ],
      },
      { name: '$solver', internalType: 'address', type: 'address' },
      { name: '$gas', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'plug',
    outputs: [
      {
        name: '$results',
        internalType: 'struct PlugTypesLib.Result[]',
        type: 'tuple[]',
        components: [
          { name: 'success', internalType: 'bool', type: 'bool' },
          { name: 'result', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '$plugs',
        internalType: 'struct PlugTypesLib.Plugs',
        type: 'tuple',
        components: [
          { name: 'socket', internalType: 'address', type: 'address' },
          {
            name: 'plugs',
            internalType: 'struct PlugTypesLib.Plug[]',
            type: 'tuple[]',
            components: [
              { name: 'target', internalType: 'address', type: 'address' },
              { name: 'value', internalType: 'uint256', type: 'uint256' },
              { name: 'data', internalType: 'bytes', type: 'bytes' },
            ],
          },
          { name: 'solver', internalType: 'bytes', type: 'bytes' },
          { name: 'salt', internalType: 'bytes32', type: 'bytes32' },
        ],
      },
    ],
    name: 'plug',
    outputs: [
      {
        name: '$results',
        internalType: 'struct PlugTypesLib.Result[]',
        type: 'tuple[]',
        components: [
          { name: 'success', internalType: 'bool', type: 'bool' },
          { name: 'result', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'proxiableUUID',
    outputs: [{ name: '', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'renounceOwnership',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'requestOwnershipHandover',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'symbol',
    outputs: [{ name: '$symbol', internalType: 'string', type: 'string' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: 'newOwner', internalType: 'address', type: 'address' }],
    name: 'transferOwnership',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'newImplementation', internalType: 'address', type: 'address' },
      { name: 'data', internalType: 'bytes', type: 'bytes' },
    ],
    name: 'upgradeToAndCall',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'version',
    outputs: [{ name: '$version', internalType: 'string', type: 'string' }],
    stateMutability: 'pure',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'pendingOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipHandoverCanceled',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'pendingOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipHandoverRequested',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'oldOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'newOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipTransferred',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '$plugsHash',
        internalType: 'bytes32',
        type: 'bytes32',
        indexed: true,
      },
      {
        name: '$results',
        internalType: 'struct PlugTypesLib.Result[]',
        type: 'tuple[]',
        components: [
          { name: 'success', internalType: 'bool', type: 'bool' },
          { name: 'result', internalType: 'bytes', type: 'bytes' },
        ],
        indexed: false,
      },
    ],
    name: 'PlugsExecuted',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'implementation',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'Upgraded',
  },
  { type: 'error', inputs: [], name: 'AlreadyInitialized' },
  {
    type: 'error',
    inputs: [
      { name: '$expected', internalType: 'address', type: 'address' },
      { name: '$reality', internalType: 'address', type: 'address' },
    ],
    name: 'CallerInvalid',
  },
  {
    type: 'error',
    inputs: [
      { name: '$recipient', internalType: 'address', type: 'address' },
      { name: '$value', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'CompensationFailed',
  },
  { type: 'error', inputs: [], name: 'NewOwnerIsZeroAddress' },
  { type: 'error', inputs: [], name: 'NoHandoverRequest' },
  { type: 'error', inputs: [], name: 'PlugFailed' },
  { type: 'error', inputs: [], name: 'Reentrancy' },
  {
    type: 'error',
    inputs: [{ name: '$reality', internalType: 'address', type: 'address' }],
    name: 'RouterInvalid',
  },
  {
    type: 'error',
    inputs: [{ name: '$reality', internalType: 'address', type: 'address' }],
    name: 'SenderInvalid',
  },
  { type: 'error', inputs: [], name: 'SignatureInvalid' },
  {
    type: 'error',
    inputs: [
      { name: '$expected', internalType: 'address', type: 'address' },
      { name: '$reality', internalType: 'address', type: 'address' },
    ],
    name: 'SolverInvalid',
  },
  { type: 'error', inputs: [], name: 'Unauthorized' },
  { type: 'error', inputs: [], name: 'UnauthorizedCallContext' },
  { type: 'error', inputs: [], name: 'UpgradeFailed' },
  {
    type: 'error',
    inputs: [
      { name: '$recipient', internalType: 'address', type: 'address' },
      { name: '$expected', internalType: 'uint256', type: 'uint256' },
      { name: '$reality', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'ValueInvalid',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// React
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugAbi}__
 */
export const useReadPlug = /*#__PURE__*/ createUseReadContract({ abi: plugAbi })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugAbi}__ and `functionName` set to `"name"`
 */
export const useReadPlugName = /*#__PURE__*/ createUseReadContract({
  abi: plugAbi,
  functionName: 'name',
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugAbi}__ and `functionName` set to `"symbol"`
 */
export const useReadPlugSymbol = /*#__PURE__*/ createUseReadContract({
  abi: plugAbi,
  functionName: 'symbol',
})

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugAbi}__
 */
export const useWritePlug = /*#__PURE__*/ createUseWriteContract({
  abi: plugAbi,
})

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugAbi}__ and `functionName` set to `"plug"`
 */
export const useWritePlugPlug = /*#__PURE__*/ createUseWriteContract({
  abi: plugAbi,
  functionName: 'plug',
})

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugAbi}__
 */
export const useSimulatePlug = /*#__PURE__*/ createUseSimulateContract({
  abi: plugAbi,
})

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugAbi}__ and `functionName` set to `"plug"`
 */
export const useSimulatePlugPlug = /*#__PURE__*/ createUseSimulateContract({
  abi: plugAbi,
  functionName: 'plug',
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugFactoryAbi}__
 */
export const useReadPlugFactory = /*#__PURE__*/ createUseReadContract({
  abi: plugFactoryAbi,
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"getAddress"`
 */
export const useReadPlugFactoryGetAddress = /*#__PURE__*/ createUseReadContract(
  { abi: plugFactoryAbi, functionName: 'getAddress' },
)

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"implementations"`
 */
export const useReadPlugFactoryImplementations =
  /*#__PURE__*/ createUseReadContract({
    abi: plugFactoryAbi,
    functionName: 'implementations',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"initCodeHash"`
 */
export const useReadPlugFactoryInitCodeHash =
  /*#__PURE__*/ createUseReadContract({
    abi: plugFactoryAbi,
    functionName: 'initCodeHash',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"owner"`
 */
export const useReadPlugFactoryOwner = /*#__PURE__*/ createUseReadContract({
  abi: plugFactoryAbi,
  functionName: 'owner',
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"ownershipHandoverExpiresAt"`
 */
export const useReadPlugFactoryOwnershipHandoverExpiresAt =
  /*#__PURE__*/ createUseReadContract({
    abi: plugFactoryAbi,
    functionName: 'ownershipHandoverExpiresAt',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__
 */
export const useWritePlugFactory = /*#__PURE__*/ createUseWriteContract({
  abi: plugFactoryAbi,
})

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"cancelOwnershipHandover"`
 */
export const useWritePlugFactoryCancelOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugFactoryAbi,
    functionName: 'cancelOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"completeOwnershipHandover"`
 */
export const useWritePlugFactoryCompleteOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugFactoryAbi,
    functionName: 'completeOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"deploy"`
 */
export const useWritePlugFactoryDeploy = /*#__PURE__*/ createUseWriteContract({
  abi: plugFactoryAbi,
  functionName: 'deploy',
})

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"initialize"`
 */
export const useWritePlugFactoryInitialize =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugFactoryAbi,
    functionName: 'initialize',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"renounceOwnership"`
 */
export const useWritePlugFactoryRenounceOwnership =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugFactoryAbi,
    functionName: 'renounceOwnership',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"requestOwnershipHandover"`
 */
export const useWritePlugFactoryRequestOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugFactoryAbi,
    functionName: 'requestOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"setImplementation"`
 */
export const useWritePlugFactorySetImplementation =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugFactoryAbi,
    functionName: 'setImplementation',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"transferOwnership"`
 */
export const useWritePlugFactoryTransferOwnership =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugFactoryAbi,
    functionName: 'transferOwnership',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__
 */
export const useSimulatePlugFactory = /*#__PURE__*/ createUseSimulateContract({
  abi: plugFactoryAbi,
})

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"cancelOwnershipHandover"`
 */
export const useSimulatePlugFactoryCancelOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'cancelOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"completeOwnershipHandover"`
 */
export const useSimulatePlugFactoryCompleteOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'completeOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"deploy"`
 */
export const useSimulatePlugFactoryDeploy =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'deploy',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"initialize"`
 */
export const useSimulatePlugFactoryInitialize =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'initialize',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"renounceOwnership"`
 */
export const useSimulatePlugFactoryRenounceOwnership =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'renounceOwnership',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"requestOwnershipHandover"`
 */
export const useSimulatePlugFactoryRequestOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'requestOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"setImplementation"`
 */
export const useSimulatePlugFactorySetImplementation =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'setImplementation',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugFactoryAbi}__ and `functionName` set to `"transferOwnership"`
 */
export const useSimulatePlugFactoryTransferOwnership =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugFactoryAbi,
    functionName: 'transferOwnership',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugFactoryAbi}__
 */
export const useWatchPlugFactoryEvent =
  /*#__PURE__*/ createUseWatchContractEvent({ abi: plugFactoryAbi })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugFactoryAbi}__ and `eventName` set to `"OwnershipHandoverCanceled"`
 */
export const useWatchPlugFactoryOwnershipHandoverCanceledEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugFactoryAbi,
    eventName: 'OwnershipHandoverCanceled',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugFactoryAbi}__ and `eventName` set to `"OwnershipHandoverRequested"`
 */
export const useWatchPlugFactoryOwnershipHandoverRequestedEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugFactoryAbi,
    eventName: 'OwnershipHandoverRequested',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugFactoryAbi}__ and `eventName` set to `"OwnershipTransferred"`
 */
export const useWatchPlugFactoryOwnershipTransferredEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugFactoryAbi,
    eventName: 'OwnershipTransferred',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugFactoryAbi}__ and `eventName` set to `"SocketDeployed"`
 */
export const useWatchPlugFactorySocketDeployedEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugFactoryAbi,
    eventName: 'SocketDeployed',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugTreasuryAbi}__
 */
export const useReadPlugTreasury = /*#__PURE__*/ createUseReadContract({
  abi: plugTreasuryAbi,
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"owner"`
 */
export const useReadPlugTreasuryOwner = /*#__PURE__*/ createUseReadContract({
  abi: plugTreasuryAbi,
  functionName: 'owner',
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"ownershipHandoverExpiresAt"`
 */
export const useReadPlugTreasuryOwnershipHandoverExpiresAt =
  /*#__PURE__*/ createUseReadContract({
    abi: plugTreasuryAbi,
    functionName: 'ownershipHandoverExpiresAt',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"targetToAllowed"`
 */
export const useReadPlugTreasuryTargetToAllowed =
  /*#__PURE__*/ createUseReadContract({
    abi: plugTreasuryAbi,
    functionName: 'targetToAllowed',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__
 */
export const useWritePlugTreasury = /*#__PURE__*/ createUseWriteContract({
  abi: plugTreasuryAbi,
})

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"cancelOwnershipHandover"`
 */
export const useWritePlugTreasuryCancelOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'cancelOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"completeOwnershipHandover"`
 */
export const useWritePlugTreasuryCompleteOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'completeOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"execute"`
 */
export const useWritePlugTreasuryExecute = /*#__PURE__*/ createUseWriteContract(
  { abi: plugTreasuryAbi, functionName: 'execute' },
)

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"initialize"`
 */
export const useWritePlugTreasuryInitialize =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'initialize',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugNative"`
 */
export const useWritePlugTreasuryPlugNative =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'plugNative',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugNativeToToken"`
 */
export const useWritePlugTreasuryPlugNativeToToken =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'plugNativeToToken',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugToken"`
 */
export const useWritePlugTreasuryPlugToken =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'plugToken',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugTokenToNative"`
 */
export const useWritePlugTreasuryPlugTokenToNative =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'plugTokenToNative',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugTokenToToken"`
 */
export const useWritePlugTreasuryPlugTokenToToken =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'plugTokenToToken',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"renounceOwnership"`
 */
export const useWritePlugTreasuryRenounceOwnership =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'renounceOwnership',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"requestOwnershipHandover"`
 */
export const useWritePlugTreasuryRequestOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'requestOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"setTargetsAllowed"`
 */
export const useWritePlugTreasurySetTargetsAllowed =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'setTargetsAllowed',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"transferOwnership"`
 */
export const useWritePlugTreasuryTransferOwnership =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugTreasuryAbi,
    functionName: 'transferOwnership',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__
 */
export const useSimulatePlugTreasury = /*#__PURE__*/ createUseSimulateContract({
  abi: plugTreasuryAbi,
})

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"cancelOwnershipHandover"`
 */
export const useSimulatePlugTreasuryCancelOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'cancelOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"completeOwnershipHandover"`
 */
export const useSimulatePlugTreasuryCompleteOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'completeOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"execute"`
 */
export const useSimulatePlugTreasuryExecute =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'execute',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"initialize"`
 */
export const useSimulatePlugTreasuryInitialize =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'initialize',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugNative"`
 */
export const useSimulatePlugTreasuryPlugNative =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'plugNative',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugNativeToToken"`
 */
export const useSimulatePlugTreasuryPlugNativeToToken =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'plugNativeToToken',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugToken"`
 */
export const useSimulatePlugTreasuryPlugToken =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'plugToken',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugTokenToNative"`
 */
export const useSimulatePlugTreasuryPlugTokenToNative =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'plugTokenToNative',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"plugTokenToToken"`
 */
export const useSimulatePlugTreasuryPlugTokenToToken =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'plugTokenToToken',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"renounceOwnership"`
 */
export const useSimulatePlugTreasuryRenounceOwnership =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'renounceOwnership',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"requestOwnershipHandover"`
 */
export const useSimulatePlugTreasuryRequestOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'requestOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"setTargetsAllowed"`
 */
export const useSimulatePlugTreasurySetTargetsAllowed =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'setTargetsAllowed',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugTreasuryAbi}__ and `functionName` set to `"transferOwnership"`
 */
export const useSimulatePlugTreasuryTransferOwnership =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugTreasuryAbi,
    functionName: 'transferOwnership',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugTreasuryAbi}__
 */
export const useWatchPlugTreasuryEvent =
  /*#__PURE__*/ createUseWatchContractEvent({ abi: plugTreasuryAbi })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugTreasuryAbi}__ and `eventName` set to `"OwnershipHandoverCanceled"`
 */
export const useWatchPlugTreasuryOwnershipHandoverCanceledEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugTreasuryAbi,
    eventName: 'OwnershipHandoverCanceled',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugTreasuryAbi}__ and `eventName` set to `"OwnershipHandoverRequested"`
 */
export const useWatchPlugTreasuryOwnershipHandoverRequestedEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugTreasuryAbi,
    eventName: 'OwnershipHandoverRequested',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugTreasuryAbi}__ and `eventName` set to `"OwnershipTransferred"`
 */
export const useWatchPlugTreasuryOwnershipTransferredEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugTreasuryAbi,
    eventName: 'OwnershipTransferred',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__
 */
export const useReadPlugVaultSocket = /*#__PURE__*/ createUseReadContract({
  abi: plugVaultSocketAbi,
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"getEIP712DomainHash"`
 */
export const useReadPlugVaultSocketGetEip712DomainHash =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'getEIP712DomainHash',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"getLivePlugsHash"`
 */
export const useReadPlugVaultSocketGetLivePlugsHash =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'getLivePlugsHash',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"getPlugArrayHash"`
 */
export const useReadPlugVaultSocketGetPlugArrayHash =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'getPlugArrayHash',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"getPlugHash"`
 */
export const useReadPlugVaultSocketGetPlugHash =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'getPlugHash',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"getPlugsHash"`
 */
export const useReadPlugVaultSocketGetPlugsHash =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'getPlugsHash',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"name"`
 */
export const useReadPlugVaultSocketName = /*#__PURE__*/ createUseReadContract({
  abi: plugVaultSocketAbi,
  functionName: 'name',
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"owner"`
 */
export const useReadPlugVaultSocketOwner = /*#__PURE__*/ createUseReadContract({
  abi: plugVaultSocketAbi,
  functionName: 'owner',
})

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"ownershipHandoverExpiresAt"`
 */
export const useReadPlugVaultSocketOwnershipHandoverExpiresAt =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'ownershipHandoverExpiresAt',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"proxiableUUID"`
 */
export const useReadPlugVaultSocketProxiableUuid =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'proxiableUUID',
  })

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"symbol"`
 */
export const useReadPlugVaultSocketSymbol = /*#__PURE__*/ createUseReadContract(
  { abi: plugVaultSocketAbi, functionName: 'symbol' },
)

/**
 * Wraps __{@link useReadContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"version"`
 */
export const useReadPlugVaultSocketVersion =
  /*#__PURE__*/ createUseReadContract({
    abi: plugVaultSocketAbi,
    functionName: 'version',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__
 */
export const useWritePlugVaultSocket = /*#__PURE__*/ createUseWriteContract({
  abi: plugVaultSocketAbi,
})

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"cancelOwnershipHandover"`
 */
export const useWritePlugVaultSocketCancelOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugVaultSocketAbi,
    functionName: 'cancelOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"completeOwnershipHandover"`
 */
export const useWritePlugVaultSocketCompleteOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugVaultSocketAbi,
    functionName: 'completeOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"initialize"`
 */
export const useWritePlugVaultSocketInitialize =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugVaultSocketAbi,
    functionName: 'initialize',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"plug"`
 */
export const useWritePlugVaultSocketPlug = /*#__PURE__*/ createUseWriteContract(
  { abi: plugVaultSocketAbi, functionName: 'plug' },
)

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"renounceOwnership"`
 */
export const useWritePlugVaultSocketRenounceOwnership =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugVaultSocketAbi,
    functionName: 'renounceOwnership',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"requestOwnershipHandover"`
 */
export const useWritePlugVaultSocketRequestOwnershipHandover =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugVaultSocketAbi,
    functionName: 'requestOwnershipHandover',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"transferOwnership"`
 */
export const useWritePlugVaultSocketTransferOwnership =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugVaultSocketAbi,
    functionName: 'transferOwnership',
  })

/**
 * Wraps __{@link useWriteContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"upgradeToAndCall"`
 */
export const useWritePlugVaultSocketUpgradeToAndCall =
  /*#__PURE__*/ createUseWriteContract({
    abi: plugVaultSocketAbi,
    functionName: 'upgradeToAndCall',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__
 */
export const useSimulatePlugVaultSocket =
  /*#__PURE__*/ createUseSimulateContract({ abi: plugVaultSocketAbi })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"cancelOwnershipHandover"`
 */
export const useSimulatePlugVaultSocketCancelOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'cancelOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"completeOwnershipHandover"`
 */
export const useSimulatePlugVaultSocketCompleteOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'completeOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"initialize"`
 */
export const useSimulatePlugVaultSocketInitialize =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'initialize',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"plug"`
 */
export const useSimulatePlugVaultSocketPlug =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'plug',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"renounceOwnership"`
 */
export const useSimulatePlugVaultSocketRenounceOwnership =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'renounceOwnership',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"requestOwnershipHandover"`
 */
export const useSimulatePlugVaultSocketRequestOwnershipHandover =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'requestOwnershipHandover',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"transferOwnership"`
 */
export const useSimulatePlugVaultSocketTransferOwnership =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'transferOwnership',
  })

/**
 * Wraps __{@link useSimulateContract}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `functionName` set to `"upgradeToAndCall"`
 */
export const useSimulatePlugVaultSocketUpgradeToAndCall =
  /*#__PURE__*/ createUseSimulateContract({
    abi: plugVaultSocketAbi,
    functionName: 'upgradeToAndCall',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugVaultSocketAbi}__
 */
export const useWatchPlugVaultSocketEvent =
  /*#__PURE__*/ createUseWatchContractEvent({ abi: plugVaultSocketAbi })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `eventName` set to `"OwnershipHandoverCanceled"`
 */
export const useWatchPlugVaultSocketOwnershipHandoverCanceledEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugVaultSocketAbi,
    eventName: 'OwnershipHandoverCanceled',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `eventName` set to `"OwnershipHandoverRequested"`
 */
export const useWatchPlugVaultSocketOwnershipHandoverRequestedEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugVaultSocketAbi,
    eventName: 'OwnershipHandoverRequested',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `eventName` set to `"OwnershipTransferred"`
 */
export const useWatchPlugVaultSocketOwnershipTransferredEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugVaultSocketAbi,
    eventName: 'OwnershipTransferred',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `eventName` set to `"PlugsExecuted"`
 */
export const useWatchPlugVaultSocketPlugsExecutedEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugVaultSocketAbi,
    eventName: 'PlugsExecuted',
  })

/**
 * Wraps __{@link useWatchContractEvent}__ with `abi` set to __{@link plugVaultSocketAbi}__ and `eventName` set to `"Upgraded"`
 */
export const useWatchPlugVaultSocketUpgradedEvent =
  /*#__PURE__*/ createUseWatchContractEvent({
    abi: plugVaultSocketAbi,
    eventName: 'Upgraded',
  })
