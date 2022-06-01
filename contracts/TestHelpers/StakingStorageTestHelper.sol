// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../StakingStorage.sol";
import "../helpers/IStaking.sol";

/**
 * @dev ASM LP Time test helper + SETTERS for testing
 */
contract StakingStorageTestHelper is StakingStorage {
    uint256 public currentTimestamp;

    /** ----------------------------------
     * ! Variables setters
     * ----------------------------------- */
    constructor() StakingStorage() {}
}
