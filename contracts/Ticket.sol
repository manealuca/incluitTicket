pragma solidity ^0.8.17;

import "./States.sol";

contract Ticket{
    uint public _ticketId;
    string  _eventName;
    string _eventDescription;
    EventType public _eventType;
    uint256  public _price;
    TicketStatus _ticketStatus;
    TransferStatus public _transferStatus;
    address public _owner;
    bool public Created;
    
    constructor(string  memory name, string memory eventDescription, EventType eventType, uint256 price, TransferStatus transferStatus,address owner,uint256 id){
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

    event ShowTicketStatus(Ticket ticket);

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

    function viewStatus(Ticket ticket)public {
        emit ShowTicketStatus(ticket);
    }
    //https://github.com/CryptozombiesHQ/cryptozombies-lesson-code
}