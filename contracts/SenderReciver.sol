// IF YOU WANNA CALL THE CONTRACT WITH TWO SENDER AND RECIVER
// USE THIS:

// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.24;

// contract Transfer {
//     event FundsTransferred(address indexed from, address indexed to, uint amount);

//     address public owner;
//     address payable public receiver;

//     constructor(address _owner, address payable _receiver) {
//         owner = _owner;           //  owner
//         receiver = _receiver;     //  receiver
//     }

//     function sendToReceiver() external payable {
//         require(msg.value > 0, "You must send some ETH");

//         (bool success, ) = receiver.call{value: msg.value}("");
//         require(success, "ETH Transfer failed");

//         emit FundsTransferred(msg.sender, receiver, msg.value);
//     }

//     receive() external payable {
//         (bool success, ) = receiver.call{value: msg.value}("");
//         require(success, "Direct ETH transfer failed");

//         emit FundsTransferred(msg.sender, receiver, msg.value);
//     }

//     fallback() external payable {
//         revert("Function does not exist");
//     }
// }
