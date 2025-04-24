// Level 0 its a simple Transfer contract, witch is only give you ability to send ETH to who deploy this contract.
// pragma solidity ^0.8.24;

// contract Transfer {

//     event Transfer( address indexed from, address indexed to ,uint indexed amount );

//     constructor(address payable _receiver) { recevier = _receiver;  }
  
//     address payable public recevier;

//     function sendToReciver() external payable {
//         require(msg.value > 0, "You must send some ETH");
//         recevier.transfer(msg.value);
//         emit Transfer(msg.sender, recevier, msg.value);
//     }
// }


// Level 1 its still a  simple Transfer contract but with more security such as security via .call and recvieving directly ETH via recevi.
// pragma solidity ^0.8.24;

// contract Transfer {
//     event Transfer(address indexed from, address indexed to, uint amount);

//     address payable public recevier;

//     constructor(address payable _receiver) {
//         recevier = _receiver;
//     }

//     function sendToReciver() external payable {
//         require(msg.value > 0, "Send some ETH");
//         (bool success, ) = recevier.call{value: msg.value}("");
//         require(success, "ETH transfer failed");

//         emit Transfer(msg.sender, recevier, msg.value);
//     }

//     receive() external payable {}
// }

// // Level 2 its still a  simple Transfer contract but with more security
// // Such as using receive that is a method  that when someone send to contract only ETH without other req data runs.
// // And fallback, that when user call method or functions from our contracts witch isnt on our contract.
// pragma solidity ^0.8.24;

// contract Transfer {
//     event transfered(address indexed from, address indexed to, uint amount);

//     address payable public recevier;

//     constructor(address payable _receiver) {
//         recevier = _receiver;
//     }

//     function sendToReciver() external payable {
//         require(msg.value > 0, "You must send some ETH");

//         (bool success, ) = recevier.call{value: msg.value}("");
//         require(success, "ETH Transfer failed");

//         emit transfered(msg.sender, recevier, msg.value);
//     }

//     receive() external payable {
//         (bool success, ) = recevier.call{value: msg.value}("");
//         require(success, "Direct ETH transfer failed");
//         emit transfered(msg.sender, recevier, msg.value);
//     }

//     // If someone calls a non-existent function
//     fallback() external payable {
//         revert("Function does not exist");
//     }
// }



// // Level 3 its still that simple contract, but the owner address is defined..
// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.24;

// contract Transfer {
//     event FundsTransferred(address indexed from, address indexed to, uint amount);

//     address payable public constant owner = payable(address(uint160(0x814EabE6C22a4ba2B7658702cd9cB56155DbD34f)));
//     constructor() { }

//     function sendToOwner() external payable {
//         require(msg.value > 0, "Send some ETH");

//         (bool success, ) = owner.call{value: msg.value}("");
//         require(success, "ETH Transfer failed");

//         emit FundsTransferred(msg.sender, owner, msg.value);
//     }

//     receive() external payable {
//         (bool success, ) = owner.call{value: msg.value}("");
//         require(success, "Direct ETH transfer failed");

//         emit FundsTransferred(msg.sender, owner, msg.value);
//     }

//     fallback() external payable {
//         revert("Function does not exist");
//     }
// }


// // Level 4 its become more useful, its taking reciver address and send from sender to reciver and owner grab some fee from it
// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.24;

// contract Transfer {
    
//     event FundsTransferred(address indexed sender, address indexed receiver, uint amount);
//     event CommissionPaid(address indexed owner, uint amount);
//     event MessageLogged(address indexed sender, address indexed receiver, uint amount, string message);

//     address payable public owner;

//     constructor() {
//         owner = payable(msg.sender);  //تبدیل یک ادرس ساده به payable
//     }

//     function sendTo(address payable receiver, string calldata message) external payable {
//         require(msg.value > 0, "Send some ETH");
//         require(receiver != address(0), "Receiver address?");

//         (uint ownerShare, uint receiverShare) = calculateShares(msg.value);

//         (bool sentReceiver, ) = receiver.call{value: receiverShare}("");
//         require(sentReceiver, "ETH transfer to receiver failed");

//         (bool sentOwner, ) = owner.call{value: ownerShare}("");
//         require(sentOwner, "ETH transfer to owner failed");

//         emit FundsTransferred(msg.sender, receiver, receiverShare);
//         emit CommissionPaid(owner, ownerShare);
//         emit MessageLogged(msg.sender, receiver, msg.value, message); 
//     }

//     function calculateShares(uint totalAmount) internal pure returns (uint ownerShare, uint receiverShare) {
//         ownerShare = totalAmount / 100; // 1% fee 
//         receiverShare = totalAmount - ownerShare;
//         return (ownerShare, receiverShare);
//     }

//     receive() external payable {
//         revert("Direct payments not allowed. Use sendTo.");
//     }

//     fallback() external payable {
//         revert("Function does not exist");
//     }
// }



//Level 5, adding more intermediet things such as Escrow and confrim the PaymentProcess, adding more emit and using enum for not give owner the money...
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract Transfer {
    event PaymentProcessed(
        address indexed sender,
        address indexed receiver,
        uint receiverAmount,
        uint ownerAmount,
        string message
    );

    event EscrowCreated(
        uint indexed dealId,
        address indexed sender,
        address indexed receiver,
        uint amount,
        string message
    );

    event EscrowReleased(
        uint indexed dealId,
        address indexed receiver,
        uint amount
    );

    event EscrowCancelled(
        uint indexed dealId,
        address indexed sender,
        uint amount
    );

    address public owner;

    enum DealStatus { Pending, Released, Cancelled }

    struct EscrowDeal {
        address sender;
        address payable receiver;
        uint amount;
        string message;
        DealStatus status;
    }

    mapping(uint => EscrowDeal) public deals;
    uint public dealCount;

    constructor() {
        owner = msg.sender;
    }

    function sendTo(address payable receiver, string calldata message)
        external
        payable
    {
        require(msg.value > 0, "Send some ETH");
        require(receiver != address(0), "Receiver address?");

        (uint ownerShare, uint receiverShare) = calculateShares(msg.value);

        (bool sentReceiver, ) = receiver.call{value: receiverShare}("");
        require(sentReceiver, "ETH transfer to receiver failed");

        (bool sentOwner, ) = payable(owner).call{value: ownerShare}("");
        require(sentOwner, "ETH transfer to owner failed");

        emit PaymentProcessed(
            msg.sender,
            receiver,
            receiverShare,
            ownerShare,
            message
        );
    }

    function createDeal(address payable receiver, string calldata message)
        external
        payable
    {
        require(msg.value > 0, "Send some ETH");
        require(receiver != address(0), "Invalid receiver");

        deals[dealCount] = EscrowDeal({
            sender: msg.sender,
            receiver: receiver,
            amount: msg.value,
            message: message,
            status: DealStatus.Pending
        });

        emit EscrowCreated(dealCount, msg.sender, receiver, msg.value, message);
        dealCount++;
    }

    function releaseDeal(uint dealId) external {
        EscrowDeal storage deal = deals[dealId];
        require(msg.sender == deal.sender, "Only sender can release");
        require(deal.status == DealStatus.Pending, "Not pending");

        deal.status = DealStatus.Released;

        (bool sent, ) = deal.receiver.call{value: deal.amount}("");
        require(sent, "Transfer to receiver failed");

        emit EscrowReleased(dealId, deal.receiver, deal.amount);
    }

    function cancelDeal(uint dealId) external {
        EscrowDeal storage deal = deals[dealId];
        require(msg.sender == deal.sender || msg.sender == owner, "Not authorized");
        require(deal.status == DealStatus.Pending, "Already processed");

        deal.status = DealStatus.Cancelled;

        (bool sent, ) = payable(deal.sender).call{value: deal.amount}("");
        require(sent, "Refund failed");

        emit EscrowCancelled(dealId, deal.sender, deal.amount);
    }

    function calculateShares(uint totalAmount)
        internal
        pure
        returns (uint ownerShare, uint receiverShare)
    {
        ownerShare = totalAmount / 100; // 1% fee
        receiverShare = totalAmount - ownerShare;
        return (ownerShare, receiverShare);
    }

    receive() external payable {
        revert("Direct payments not allowed. Use sendTo.");
    }

    fallback() external payable {
        revert("Function does not exist");
    }
}







