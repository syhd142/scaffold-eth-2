// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    mapping(address => uint256) public balances;
    uint256 public constant threshold = 1 ether;
    uint256 public deadline = block.timestamp + 30 seconds;

    ExampleExternalContract public exampleExternalContract;
   
    event Stake(address, uint256);
    event Log(uint256, uint256);

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }
   
    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
    function stake() public payable {
        console.log(block.timestamp, deadline);

        require(block.timestamp < deadline, "stake time reached!");

        balances[msg.sender] += msg.value;

        emit Stake(msg.sender, msg.value);

    }
   
    // After some `deadline` allow anyone to call an `execute()` function
    // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
    function execute() public {
        console.log(block.timestamp, deadline);

        require(block.timestamp >= deadline, "timeleft");
        require(address(this).balance > threshold, "threshould not met");
        require(exampleExternalContract.hasComplete(), "you can only execute once");

        exampleExternalContract.complete{value: address(this).balance}();
    }
   
   
    // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
    function withdraw() public {
        console.log(block.timestamp, deadline);

        require(block.timestamp < deadline, "time's up");
        require(address(this).balance < threshold, "threshould meted");

        uint256 stakeEth = balances[msg.sender];
        payable(msg.sender).transfer(stakeEth);
    }
   
    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
    function timeLeft() public view returns(uint256) {
        uint256 timeleft = deadline - block.timestamp;
        if (timeleft < 0) {
            timeleft = 0;
        }

        return timeleft;
    }
   
    // Add the `receive()` special function that receives eth and calls stake()
    // function reveive public payable {
    // }
}
