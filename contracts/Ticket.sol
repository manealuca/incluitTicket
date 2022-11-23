pragma solidity ^0.8.17;

import "./States.sol";

contract Ticket{
    uint _ticketId;
    string  _eventName;
    string _eventDescription;
    EvenType _eventType;
    uint256  _price;
    TicketStatus _ticketStatus;
    TransferStatus _transferStatus;
    address _owner;
    bool Created;
    
    constructor(string  memory name, string memory eventDescription, EvenType eventType, uint256 price, TransferStatus transferStatus,address owner,uint256 id){
        _owner = owner;
        _eventName = name;
        _eventDescription = eventDescription;
        _price = price;
        _eventType = eventType;
        _transferStatus = transferStatus;
        _ticketId = id;
        Created = true;        
    }

    

    modifier isOwner{
        require(msg.sender == _owner,"");
        _;
    }

    function ChangePrice(uint newPrice)public  isOwner{
        _price = newPrice;
    }

    function ChangeTraansferStatus(TransferStatus status)public {
        _transferStatus = status;
    }

    function changeStatus(TicketStatus status)public{
        _ticketStatus = status;
    }
    function changeOwner(address newOwner) public isOwner{
        _owner = newOwner;
    }

    //https://github.com/CryptozombiesHQ/cryptozombies-lesson-code

    //https://github.com/MauroPerna/sc-ticketapp

}