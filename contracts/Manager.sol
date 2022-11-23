pragma solidity ^0.8.17;

import "./Ticket.sol";
import "./States.sol";

contract Manager{

    constructor(){
        Counter = 0;
        acum = 0;       
    }
    
    uint256 initialTicketValue;
    address private owner;
    Ticket [] tickets;
    //IdTicket
    uint256 Counter;
    //ArrayLenght
    uint256 acum;    
    modifier EnoughtBalance{
        require(msg.value >= initialTicketValue,"You don have enought balance to mint this ticket");
        _;
    }

    }
    function CreateTicket(string memory name, string memory description, EventType eventTYpe) public payable  EnoughtBalance{
        Counter+=1;
        Ticket  newTicket = new Ticket(name,description,eventTYpe,initialTicketValue,TransferStatus.Transferible,msg.sender, Counter);
        if(newTiket.Created){
            tickets.push(newTicket);
            acum +=1;
        }else {
            Counter-=1;
            revert();
        }
    }

    function ShowAllTickets() public {
        for(int i = 0 ; i<acum;i++){
            //Todo Lanzar evento para mostrar ticket
        }
    }

    function ShowTicketsByAddress(uint ticketId) public {
        //Evento para mostrar ticket segun su id
    }

    function TransferTicket()public payable{

    }
    function ChangeTicketPrice(uint256 ticketId,uint256 newPrice) public {
        //Todo Checkear Logica para ejecutar al realizarce una transferencia
        tickets[ticketId].ChangePrice(newPrice);
    }
    function ShowStatistcs()public{

    }
}