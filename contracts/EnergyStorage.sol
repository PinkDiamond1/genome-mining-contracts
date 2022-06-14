// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./helpers/Util.sol";
import "./helpers/PermissionControl.sol";

/**
 * @dev ASM Genome Mining - Energy Storage contract
 *
 * Store consumed energy amount for each address.
 * This contract will be called from Converter logic contract (Converter.sol)
 */
contract EnergyStorage is Util, PermissionControl {
    bool private _initialized = false;
    mapping(address => uint256) public consumedAmount;

    constructor(address controller) {
        if (!_isContract(controller)) revert ContractError(INVALID_CONTROLLER);
        _setupRole(CONTROLLER_ROLE, controller);
        _setupRole(CONSUMER_ROLE, controller);
    }

    /**
     * @dev Increase consumed energy for address `addr`
     * @dev can only be called by Converter
     *
     * @param addr The wallet address which consumed the energy
     * @param amount The amount of consumed energy
     */
    function increaseConsumedAmount(address addr, uint256 amount) external onlyRole(CONSUMER_ROLE) {
        if (address(addr) == address(0)) revert InvalidInput(WRONG_ADDRESS);
        consumedAmount[addr] += amount;
    }

    /** ----------------------------------
     * ! Admin functions
     * ----------------------------------- */

    /**
     * @dev Initialize the contract:
     * @dev only controller is allowed to call this function
     *
     * @param converterLogic Converter logic contract address
     */
    function init(address converterLogic) external onlyRole(CONTROLLER_ROLE) {
        if (_initialized) revert ContractError(ALREADY_INITIALIZED);
        if (!_isContract(converterLogic)) revert ContractError(INVALID_CONVERTER_LOGIC);

        _updateRole(CONSUMER_ROLE, converterLogic);
        _initialized = true;
    }

    /**
     * @dev Update the Controller contract address
     * @dev only controller is allowed to call this function
     */
    function setController(address newController) external onlyRole(CONTROLLER_ROLE) {
        _updateRole(CONTROLLER_ROLE, newController);
    }

    /**
     * @dev Update the Consumer contract address
     * @dev only controller is allowed to call this function
     */
    function setConsumer(address consumer) external onlyRole(CONTROLLER_ROLE) {
        _updateRole(CONSUMER_ROLE, consumer);
    }
}
