// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract DigitalBroker is AccessControlUpgradeable{

    bytes32 public constant DIGITAL_BROKER_OPERATOR = keccak256("DIGITAL_BROKER_OPERATOR");
    bytes32 public constant DIGITAL_BROKER_CLIENT = keccak256("DIGITAL_BROKER_CLIENT");
    bytes32 public constant SYSTEM_ADMIN = keccak256("SYSTEM_ADMIN");

    //keeps track of client account balance in eth
    mapping(address => uint) public clientAccountBalance;
    
    //client address token address balance
    mapping(address => mapping( address => uint)) public clientAccountBalanceToken;

    receive() external payable{
       clientAccountBalance[msg.sender] +=  msg.value;    
    }

    function withDrawnEth(uint amount) external payable onlyRole(DIGITAL_BROKER_CLIENT){
        require(clientAccountBalance[msg.sender] >= amount, "not enough balance to withDrawn");
        (bool sent, bytes memory data) = payable(msg.sender).call{value: msg.value}("");
        clientAccountBalance[msg.sender] -= amount;
        require(sent, "Failed to send Ether");
    }

}