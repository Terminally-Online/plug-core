import { Contract } from '@/src/lib/types'

export const contractsPath = 'src/contracts'

const base = (name: string): Contract => ({
    name,
    relativePath: '../base/'
})

const socket = (name: string): Contract => ({
    name,
    relativePath: '../sockets/'
})

export const router = base('Plug.sol')
export const factory = base('Plug.Factory.sol')
export const treasury = base('Plug.Treasury.sol')

export const vault = socket('Plug.Vault.Socket.sol')

export const constantContracts: Readonly<Array<Contract>> = [factory] as const
export const etchContracts: Readonly<Array<Contract>> = [
    // ! Bases
    router,
    factory,
    treasury,
    // ! Sockets
    vault,
] as const
