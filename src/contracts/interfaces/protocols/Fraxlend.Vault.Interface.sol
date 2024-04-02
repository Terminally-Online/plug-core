// SPDX-License-Identifier: MIT
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.8.0. SEE SOURCE BELOW. !!
pragma solidity 0.8.23;

interface FraxlendVaultInterface {
    error AlreadyInitialized();
    error BadProtocolFee();
    error BadSwapper();
    error BorrowerSolvent();
    error BorrowerWhitelistRequired();
    error Insolvent(
        uint256 _borrow, uint256 _collateral, uint256 _exchangeRate
    );
    error InsufficientAssetsInContract(
        uint256 _assets, uint256 _request
    );
    error InvalidPath(address _expected, address _actual);
    error NameEmpty();
    error NotDeployer();
    error NotOnWhitelist(address _address);
    error OnlyApprovedBorrowers();
    error OnlyApprovedLenders();
    error OnlyTimeLock();
    error OracleLTEZero(address _oracle);
    error PastDeadline(uint256 _blockTimestamp, uint256 _deadline);
    error PastMaturity();
    error PriceTooLarge();
    error ProtocolOrOwnerOnly();
    error SlippageTooHigh(uint256 _minOut, uint256 _actual);

    event AddCollateral(
        address indexed _sender,
        address indexed _borrower,
        uint256 _collateralAmount
    );
    event AddInterest(
        uint256 _interestEarned,
        uint256 _rate,
        uint256 _deltaTime,
        uint256 _feesAmount,
        uint256 _feesShare
    );
    event Approval(
        address indexed owner, address indexed spender, uint256 value
    );
    event BorrowAsset(
        address indexed _borrower,
        address indexed _receiver,
        uint256 _borrowAmount,
        uint256 _sharesAdded
    );
    event ChangeFee(uint32 _newFee);
    event Deposit(
        address indexed caller,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );
    event LeveragedPosition(
        address indexed _borrower,
        address _swapperAddress,
        uint256 _borrowAmount,
        uint256 _borrowShares,
        uint256 _initialCollateralAmount,
        uint256 _amountCollateralOut
    );
    event Liquidate(
        address indexed _borrower,
        uint256 _collateralForLiquidator,
        uint256 _sharesToLiquidate,
        uint256 _amountLiquidatorToRepay,
        uint256 _sharesToAdjust,
        uint256 _amountToAdjust
    );
    event OwnershipTransferred(
        address indexed previousOwner, address indexed newOwner
    );
    event Paused(address account);
    event RemoveCollateral(
        address indexed _sender,
        uint256 _collateralAmount,
        address indexed _receiver,
        address indexed _borrower
    );
    event RepayAsset(
        address indexed _payer,
        address indexed _borrower,
        uint256 _amountToRepay,
        uint256 _shares
    );
    event RepayAssetWithCollateral(
        address indexed _borrower,
        address _swapperAddress,
        uint256 _collateralToSwap,
        uint256 _amountAssetOut,
        uint256 _sharesRepaid
    );
    event SetApprovedBorrower(
        address indexed _address, bool _approval
    );
    event SetApprovedLender(address indexed _address, bool _approval);
    event SetSwapper(address _swapper, bool _approval);
    event SetTimeLock(address _oldAddress, address _newAddress);
    event Transfer(
        address indexed from, address indexed to, uint256 value
    );
    event Unpaused(address account);
    event UpdateExchangeRate(uint256 _rate);
    event UpdateRate(
        uint256 _ratePerSec,
        uint256 _deltaTime,
        uint256 _utilizationRate,
        uint256 _newRatePerSec
    );
    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );
    event WithdrawFees(
        uint128 _shares, address _recipient, uint256 _amountToTransfer
    );

    function CIRCUIT_BREAKER_ADDRESS()
        external
        view
        returns (address);
    function COMPTROLLER_ADDRESS() external view returns (address);
    function DEPLOYER_ADDRESS() external view returns (address);
    function FRAXLEND_WHITELIST_ADDRESS()
        external
        view
        returns (address);
    function TIME_LOCK_ADDRESS() external view returns (address);
    function addCollateral(
        uint256 _collateralAmount,
        address _borrower
    )
        external;
    function addInterest()
        external
        returns (
            uint256 _interestEarned,
            uint256 _feesAmount,
            uint256 _feesShare,
            uint64 _newRate
        );
    function allowance(
        address owner,
        address spender
    )
        external
        view
        returns (uint256);
    function approve(
        address spender,
        uint256 amount
    )
        external
        returns (bool);
    function approvedBorrowers(address)
        external
        view
        returns (bool);
    function approvedLenders(address) external view returns (bool);
    function asset() external view returns (address);
    function balanceOf(address account)
        external
        view
        returns (uint256);
    function borrowAsset(
        uint256 _borrowAmount,
        uint256 _collateralAmount,
        address _receiver
    )
        external
        returns (uint256 _shares);
    function borrowerWhitelistActive() external view returns (bool);
    function changeFee(uint32 _newFee) external;
    function cleanLiquidationFee() external view returns (uint256);
    function collateralContract() external view returns (address);
    function currentRateInfo()
        external
        view
        returns (
            uint64 lastBlock,
            uint64 feeToProtocolRate,
            uint64 lastTimestamp,
            uint64 ratePerSec
        );
    function decimals() external pure returns (uint8);
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    )
        external
        returns (bool);
    function deposit(
        uint256 _amount,
        address _receiver
    )
        external
        returns (uint256 _sharesReceived);
    function dirtyLiquidationFee() external view returns (uint256);
    function exchangeRateInfo()
        external
        view
        returns (uint32 lastTimestamp, uint224 exchangeRate);
    function getConstants()
        external
        pure
        returns (
            uint256 _LTV_PRECISION,
            uint256 _LIQ_PRECISION,
            uint256 _UTIL_PREC,
            uint256 _FEE_PRECISION,
            uint256 _EXCHANGE_PRECISION,
            uint64 _DEFAULT_INT,
            uint16 _DEFAULT_PROTOCOL_FEE,
            uint256 _MAX_PROTOCOL_FEE
        );
    function getImmutableAddressBool()
        external
        view
        returns (
            address _assetContract,
            address _collateralContract,
            address _oracleMultiply,
            address _oracleDivide,
            address _rateContract,
            address _DEPLOYER_CONTRACT,
            address _COMPTROLLER_ADDRESS,
            address _FRAXLEND_WHITELIST,
            bool _borrowerWhitelistActive,
            bool _lenderWhitelistActive
        );
    function getImmutableUint256()
        external
        view
        returns (
            uint256 _oracleNormalization,
            uint256 _maxLTV,
            uint256 _cleanLiquidationFee,
            uint256 _maturityDate,
            uint256 _penaltyRate
        );
    function getPairAccounting()
        external
        view
        returns (
            uint128 _totalAssetAmount,
            uint128 _totalAssetShares,
            uint128 _totalBorrowAmount,
            uint128 _totalBorrowShares,
            uint256 _totalCollateral
        );
    function getUserSnapshot(address _address)
        external
        view
        returns (
            uint256 _userAssetShares,
            uint256 _userBorrowShares,
            uint256 _userCollateralBalance
        );
    function increaseAllowance(
        address spender,
        uint256 addedValue
    )
        external
        returns (bool);
    function initialize(
        string memory _name,
        address[] memory _approvedBorrowers,
        address[] memory _approvedLenders,
        bytes memory _rateInitCallData
    )
        external;
    function lenderWhitelistActive() external view returns (bool);
    function leveragedPosition(
        address _swapperAddress,
        uint256 _borrowAmount,
        uint256 _initialCollateralAmount,
        uint256 _amountCollateralOutMin,
        address[] memory _path
    )
        external
        returns (uint256 _totalCollateralBalance);
    function liquidate(
        uint128 _sharesToLiquidate,
        uint256 _deadline,
        address _borrower
    )
        external
        returns (uint256 _collateralForLiquidator);
    function maturityDate() external view returns (uint256);
    function maxLTV() external view returns (uint256);
    function name() external view returns (string memory);
    function oracleDivide() external view returns (address);
    function oracleMultiply() external view returns (address);
    function oracleNormalization() external view returns (uint256);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function penaltyRate() external view returns (uint256);
    function rateContract() external view returns (address);
    function rateInitCallData()
        external
        view
        returns (bytes memory);
    function redeem(
        uint256 _shares,
        address _receiver,
        address _owner
    )
        external
        returns (uint256 _amountToReturn);
    function removeCollateral(
        uint256 _collateralAmount,
        address _receiver
    )
        external;
    function renounceOwnership() external;
    function repayAsset(
        uint256 _shares,
        address _borrower
    )
        external
        returns (uint256 _amountToRepay);
    function repayAssetWithCollateral(
        address _swapperAddress,
        uint256 _collateralToSwap,
        uint256 _amountAssetOutMin,
        address[] memory _path
    )
        external
        returns (uint256 _amountAssetOut);
    function setApprovedBorrowers(
        address[] memory _borrowers,
        bool _approval
    )
        external;
    function setApprovedLenders(
        address[] memory _lenders,
        bool _approval
    )
        external;
    function setSwapper(address _swapper, bool _approval) external;
    function setTimeLock(address _newAddress) external;
    function swappers(address) external view returns (bool);
    function symbol() external view returns (string memory);
    function toAssetAmount(
        uint256 _shares,
        bool _roundUp
    )
        external
        view
        returns (uint256);
    function toAssetShares(
        uint256 _amount,
        bool _roundUp
    )
        external
        view
        returns (uint256);
    function toBorrowAmount(
        uint256 _shares,
        bool _roundUp
    )
        external
        view
        returns (uint256);
    function toBorrowShares(
        uint256 _amount,
        bool _roundUp
    )
        external
        view
        returns (uint256);
    function totalAsset()
        external
        view
        returns (uint128 amount, uint128 shares);
    function totalBorrow()
        external
        view
        returns (uint128 amount, uint128 shares);
    function totalCollateral() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(
        address to,
        uint256 amount
    )
        external
        returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    )
        external
        returns (bool);
    function transferOwnership(address newOwner) external;
    function unpause() external;
    function updateExchangeRate()
        external
        returns (uint256 _exchangeRate);
    function userBorrowShares(address)
        external
        view
        returns (uint256);
    function userCollateralBalance(address)
        external
        view
        returns (uint256);
    function version() external view returns (string memory);
    function withdrawFees(
        uint128 _shares,
        address _recipient
    )
        external
        returns (uint256 _amountToTransfer);
}

// THIS FILE WAS AUTOGENERATED FROM THE FOLLOWING ABI JSON:
/*
[{"inputs":[{"internalType":"bytes","name":"_configData","type":"bytes"},{"internalType":"bytes","name":"_immutables","type":"bytes"},{"internalType":"uint256","name":"_maxLTV","type":"uint256"},{"internalType":"uint256","name":"_liquidationFee","type":"uint256"},{"internalType":"uint256","name":"_maturityDate","type":"uint256"},{"internalType":"uint256","name":"_penaltyRate","type":"uint256"},{"internalType":"bool","name":"_isBorrowerWhitelistActive","type":"bool"},{"internalType":"bool","name":"_isLenderWhitelistActive","type":"bool"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"AlreadyInitialized","type":"error"},{"inputs":[],"name":"BadProtocolFee","type":"error"},{"inputs":[],"name":"BadSwapper","type":"error"},{"inputs":[],"name":"BorrowerSolvent","type":"error"},{"inputs":[],"name":"BorrowerWhitelistRequired","type":"error"},{"inputs":[{"internalType":"uint256","name":"_borrow","type":"uint256"},{"internalType":"uint256","name":"_collateral","type":"uint256"},{"internalType":"uint256","name":"_exchangeRate","type":"uint256"}],"name":"Insolvent","type":"error"},{"inputs":[{"internalType":"uint256","name":"_assets","type":"uint256"},{"internalType":"uint256","name":"_request","type":"uint256"}],"name":"InsufficientAssetsInContract","type":"error"},{"inputs":[{"internalType":"address","name":"_expected","type":"address"},{"internalType":"address","name":"_actual","type":"address"}],"name":"InvalidPath","type":"error"},{"inputs":[],"name":"NameEmpty","type":"error"},{"inputs":[],"name":"NotDeployer","type":"error"},{"inputs":[{"internalType":"address","name":"_address","type":"address"}],"name":"NotOnWhitelist","type":"error"},{"inputs":[],"name":"OnlyApprovedBorrowers","type":"error"},{"inputs":[],"name":"OnlyApprovedLenders","type":"error"},{"inputs":[],"name":"OnlyTimeLock","type":"error"},{"inputs":[{"internalType":"address","name":"_oracle","type":"address"}],"name":"OracleLTEZero","type":"error"},{"inputs":[{"internalType":"uint256","name":"_blockTimestamp","type":"uint256"},{"internalType":"uint256","name":"_deadline","type":"uint256"}],"name":"PastDeadline","type":"error"},{"inputs":[],"name":"PastMaturity","type":"error"},{"inputs":[],"name":"PriceTooLarge","type":"error"},{"inputs":[],"name":"ProtocolOrOwnerOnly","type":"error"},{"inputs":[{"internalType":"uint256","name":"_minOut","type":"uint256"},{"internalType":"uint256","name":"_actual","type":"uint256"}],"name":"SlippageTooHigh","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_sender","type":"address"},{"indexed":true,"internalType":"address","name":"_borrower","type":"address"},{"indexed":false,"internalType":"uint256","name":"_collateralAmount","type":"uint256"}],"name":"AddCollateral","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_interestEarned","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_rate","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_deltaTime","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_feesAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_feesShare","type":"uint256"}],"name":"AddInterest","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_borrower","type":"address"},{"indexed":true,"internalType":"address","name":"_receiver","type":"address"},{"indexed":false,"internalType":"uint256","name":"_borrowAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_sharesAdded","type":"uint256"}],"name":"BorrowAsset","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint32","name":"_newFee","type":"uint32"}],"name":"ChangeFee","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"caller","type":"address"},{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":false,"internalType":"uint256","name":"assets","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"shares","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_borrower","type":"address"},{"indexed":false,"internalType":"address","name":"_swapperAddress","type":"address"},{"indexed":false,"internalType":"uint256","name":"_borrowAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_borrowShares","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_initialCollateralAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_amountCollateralOut","type":"uint256"}],"name":"LeveragedPosition","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_borrower","type":"address"},{"indexed":false,"internalType":"uint256","name":"_collateralForLiquidator","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_sharesToLiquidate","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_amountLiquidatorToRepay","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_sharesToAdjust","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_amountToAdjust","type":"uint256"}],"name":"Liquidate","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Paused","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"_collateralAmount","type":"uint256"},{"indexed":true,"internalType":"address","name":"_receiver","type":"address"},{"indexed":true,"internalType":"address","name":"_borrower","type":"address"}],"name":"RemoveCollateral","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_payer","type":"address"},{"indexed":true,"internalType":"address","name":"_borrower","type":"address"},{"indexed":false,"internalType":"uint256","name":"_amountToRepay","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_shares","type":"uint256"}],"name":"RepayAsset","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_borrower","type":"address"},{"indexed":false,"internalType":"address","name":"_swapperAddress","type":"address"},{"indexed":false,"internalType":"uint256","name":"_collateralToSwap","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_amountAssetOut","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_sharesRepaid","type":"uint256"}],"name":"RepayAssetWithCollateral","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_address","type":"address"},{"indexed":false,"internalType":"bool","name":"_approval","type":"bool"}],"name":"SetApprovedBorrower","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_address","type":"address"},{"indexed":false,"internalType":"bool","name":"_approval","type":"bool"}],"name":"SetApprovedLender","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_swapper","type":"address"},{"indexed":false,"internalType":"bool","name":"_approval","type":"bool"}],"name":"SetSwapper","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_oldAddress","type":"address"},{"indexed":false,"internalType":"address","name":"_newAddress","type":"address"}],"name":"SetTimeLock","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Unpaused","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_rate","type":"uint256"}],"name":"UpdateExchangeRate","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_ratePerSec","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_deltaTime","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_utilizationRate","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_newRatePerSec","type":"uint256"}],"name":"UpdateRate","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"caller","type":"address"},{"indexed":true,"internalType":"address","name":"receiver","type":"address"},{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":false,"internalType":"uint256","name":"assets","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"shares","type":"uint256"}],"name":"Withdraw","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint128","name":"_shares","type":"uint128"},{"indexed":false,"internalType":"address","name":"_recipient","type":"address"},{"indexed":false,"internalType":"uint256","name":"_amountToTransfer","type":"uint256"}],"name":"WithdrawFees","type":"event"},{"inputs":[],"name":"CIRCUIT_BREAKER_ADDRESS","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"COMPTROLLER_ADDRESS","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"DEPLOYER_ADDRESS","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"FRAXLEND_WHITELIST_ADDRESS","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"TIME_LOCK_ADDRESS","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_collateralAmount","type":"uint256"},{"internalType":"address","name":"_borrower","type":"address"}],"name":"addCollateral","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"addInterest","outputs":[{"internalType":"uint256","name":"_interestEarned","type":"uint256"},{"internalType":"uint256","name":"_feesAmount","type":"uint256"},{"internalType":"uint256","name":"_feesShare","type":"uint256"},{"internalType":"uint64","name":"_newRate","type":"uint64"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"approvedBorrowers","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"approvedLenders","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"asset","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_borrowAmount","type":"uint256"},{"internalType":"uint256","name":"_collateralAmount","type":"uint256"},{"internalType":"address","name":"_receiver","type":"address"}],"name":"borrowAsset","outputs":[{"internalType":"uint256","name":"_shares","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"borrowerWhitelistActive","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint32","name":"_newFee","type":"uint32"}],"name":"changeFee","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"cleanLiquidationFee","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"collateralContract","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"currentRateInfo","outputs":[{"internalType":"uint64","name":"lastBlock","type":"uint64"},{"internalType":"uint64","name":"feeToProtocolRate","type":"uint64"},{"internalType":"uint64","name":"lastTimestamp","type":"uint64"},{"internalType":"uint64","name":"ratePerSec","type":"uint64"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"},{"internalType":"address","name":"_receiver","type":"address"}],"name":"deposit","outputs":[{"internalType":"uint256","name":"_sharesReceived","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"dirtyLiquidationFee","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"exchangeRateInfo","outputs":[{"internalType":"uint32","name":"lastTimestamp","type":"uint32"},{"internalType":"uint224","name":"exchangeRate","type":"uint224"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getConstants","outputs":[{"internalType":"uint256","name":"_LTV_PRECISION","type":"uint256"},{"internalType":"uint256","name":"_LIQ_PRECISION","type":"uint256"},{"internalType":"uint256","name":"_UTIL_PREC","type":"uint256"},{"internalType":"uint256","name":"_FEE_PRECISION","type":"uint256"},{"internalType":"uint256","name":"_EXCHANGE_PRECISION","type":"uint256"},{"internalType":"uint64","name":"_DEFAULT_INT","type":"uint64"},{"internalType":"uint16","name":"_DEFAULT_PROTOCOL_FEE","type":"uint16"},{"internalType":"uint256","name":"_MAX_PROTOCOL_FEE","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"getImmutableAddressBool","outputs":[{"internalType":"address","name":"_assetContract","type":"address"},{"internalType":"address","name":"_collateralContract","type":"address"},{"internalType":"address","name":"_oracleMultiply","type":"address"},{"internalType":"address","name":"_oracleDivide","type":"address"},{"internalType":"address","name":"_rateContract","type":"address"},{"internalType":"address","name":"_DEPLOYER_CONTRACT","type":"address"},{"internalType":"address","name":"_COMPTROLLER_ADDRESS","type":"address"},{"internalType":"address","name":"_FRAXLEND_WHITELIST","type":"address"},{"internalType":"bool","name":"_borrowerWhitelistActive","type":"bool"},{"internalType":"bool","name":"_lenderWhitelistActive","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getImmutableUint256","outputs":[{"internalType":"uint256","name":"_oracleNormalization","type":"uint256"},{"internalType":"uint256","name":"_maxLTV","type":"uint256"},{"internalType":"uint256","name":"_cleanLiquidationFee","type":"uint256"},{"internalType":"uint256","name":"_maturityDate","type":"uint256"},{"internalType":"uint256","name":"_penaltyRate","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getPairAccounting","outputs":[{"internalType":"uint128","name":"_totalAssetAmount","type":"uint128"},{"internalType":"uint128","name":"_totalAssetShares","type":"uint128"},{"internalType":"uint128","name":"_totalBorrowAmount","type":"uint128"},{"internalType":"uint128","name":"_totalBorrowShares","type":"uint128"},{"internalType":"uint256","name":"_totalCollateral","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_address","type":"address"}],"name":"getUserSnapshot","outputs":[{"internalType":"uint256","name":"_userAssetShares","type":"uint256"},{"internalType":"uint256","name":"_userBorrowShares","type":"uint256"},{"internalType":"uint256","name":"_userCollateralBalance","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_name","type":"string"},{"internalType":"address[]","name":"_approvedBorrowers","type":"address[]"},{"internalType":"address[]","name":"_approvedLenders","type":"address[]"},{"internalType":"bytes","name":"_rateInitCallData","type":"bytes"}],"name":"initialize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"lenderWhitelistActive","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_swapperAddress","type":"address"},{"internalType":"uint256","name":"_borrowAmount","type":"uint256"},{"internalType":"uint256","name":"_initialCollateralAmount","type":"uint256"},{"internalType":"uint256","name":"_amountCollateralOutMin","type":"uint256"},{"internalType":"address[]","name":"_path","type":"address[]"}],"name":"leveragedPosition","outputs":[{"internalType":"uint256","name":"_totalCollateralBalance","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint128","name":"_sharesToLiquidate","type":"uint128"},{"internalType":"uint256","name":"_deadline","type":"uint256"},{"internalType":"address","name":"_borrower","type":"address"}],"name":"liquidate","outputs":[{"internalType":"uint256","name":"_collateralForLiquidator","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"maturityDate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"maxLTV","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"oracleDivide","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"oracleMultiply","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"oracleNormalization","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"penaltyRate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rateContract","outputs":[{"internalType":"contract IRateCalculator","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rateInitCallData","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_shares","type":"uint256"},{"internalType":"address","name":"_receiver","type":"address"},{"internalType":"address","name":"_owner","type":"address"}],"name":"redeem","outputs":[{"internalType":"uint256","name":"_amountToReturn","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_collateralAmount","type":"uint256"},{"internalType":"address","name":"_receiver","type":"address"}],"name":"removeCollateral","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_shares","type":"uint256"},{"internalType":"address","name":"_borrower","type":"address"}],"name":"repayAsset","outputs":[{"internalType":"uint256","name":"_amountToRepay","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_swapperAddress","type":"address"},{"internalType":"uint256","name":"_collateralToSwap","type":"uint256"},{"internalType":"uint256","name":"_amountAssetOutMin","type":"uint256"},{"internalType":"address[]","name":"_path","type":"address[]"}],"name":"repayAssetWithCollateral","outputs":[{"internalType":"uint256","name":"_amountAssetOut","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"_borrowers","type":"address[]"},{"internalType":"bool","name":"_approval","type":"bool"}],"name":"setApprovedBorrowers","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"_lenders","type":"address[]"},{"internalType":"bool","name":"_approval","type":"bool"}],"name":"setApprovedLenders","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_swapper","type":"address"},{"internalType":"bool","name":"_approval","type":"bool"}],"name":"setSwapper","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_newAddress","type":"address"}],"name":"setTimeLock","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"swappers","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_shares","type":"uint256"},{"internalType":"bool","name":"_roundUp","type":"bool"}],"name":"toAssetAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"},{"internalType":"bool","name":"_roundUp","type":"bool"}],"name":"toAssetShares","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_shares","type":"uint256"},{"internalType":"bool","name":"_roundUp","type":"bool"}],"name":"toBorrowAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"},{"internalType":"bool","name":"_roundUp","type":"bool"}],"name":"toBorrowShares","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalAsset","outputs":[{"internalType":"uint128","name":"amount","type":"uint128"},{"internalType":"uint128","name":"shares","type":"uint128"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalBorrow","outputs":[{"internalType":"uint128","name":"amount","type":"uint128"},{"internalType":"uint128","name":"shares","type":"uint128"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalCollateral","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"unpause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"updateExchangeRate","outputs":[{"internalType":"uint256","name":"_exchangeRate","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"userBorrowShares","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"userCollateralBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"version","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"_shares","type":"uint128"},{"internalType":"address","name":"_recipient","type":"address"}],"name":"withdrawFees","outputs":[{"internalType":"uint256","name":"_amountToTransfer","type":"uint256"}],"stateMutability":"nonpayable","type":"function"}]
*/