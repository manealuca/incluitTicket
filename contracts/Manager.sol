pragma solidity ^0.8.17;

import "./Ticket.sol";
import "./States.sol";

contract Manager{

    constructor(){
        Counter = 0;
        acum = 0;
        owner = msg.sender;       
    }
    struct TicketStatistcs{
        uint256 [3] totalPerTypes;
        uint256 totalPrice;
        uint256 average;
        uint256 totalTickets;
    }
    uint256 initialTicketValue;
    address private owner;
    address private bault;
    Ticket [] tickets;
    TicketStatistcs statistcs;

    //IdTicket
    uint256 Counter;
    //ArrayLenght
    uint256 acum;
    uint256 fee = 5;    
    mapping(address=>uint256[])userTickets;

    modifier EnoughtBalance{
        require(msg.value >= initialTicketValue,"You don have enought balance to mint this ticket");
        _;
    }

    modifier EnoughtBalanceToTransfer(uint256 id){
        require(msg.value >=tickets[id]._price(),"You Dont have enought balance");
        _;
    }

    modifier onlyOwner(uint256 id){
        require(msg.sender == tickets[id]._owner(),"Only the owner can delete a ticket");
        _;
    }
    modifier IsTransferible(uint256 id){
        require(tickets[id]._transferStatus() == TransferStatus.Transferible,"The Ticket  must be Transferible");
        _;
    }
    event FundsReceived(uint256 amount);
    event Statistcs(TicketStatistcs stats );
//    event ShowTicket(Ticket ticket);
    event ShowCommision(uint256 fee);
    receive() external payable{
         emit FundsReceived(msg.value);
    }
    fallback() external payable {
        emit FundsReceived(msg.value);
    }
    
    function CreateTicket(string memory name, string memory description, EventType eventType) public payable  EnoughtBalance{
        Counter+=1;
        Ticket  newTicket = new Ticket(name,description,eventType,initialTicketValue,TransferStatus.Transferible,msg.sender, Counter);
        if(newTicket.Created()){
            tickets.push(newTicket);
            acum +=1;
            userTickets[msg.sender].push(Counter);
        }else {
            Counter-=1;
            revert();
        }
    }

    function resetStaticsts()public {
        statistcs.average=0;
        statistcs.totalPrice=0;
        for(uint256 i = 0; i<statistcs.totalPerTypes.length;i++){
            statistcs.totalPerTypes[i]=0;
        }
    }
    function totalValue()public{
        resetStaticsts();
        for(uint256 i = 0 ; i<acum;i++){
           statistcs.totalPrice+=tickets[i]._price();
            if(tickets[i]._eventType() == EventType.Sports){
                statistcs.totalPerTypes[0]+=1;
                continue;
            }
            if(tickets[i]._eventType() == EventType.Music){
                statistcs.totalPerTypes[1]+=1;
                continue;
            }if(tickets[i]._eventType() == EventType.Cinema){
                statistcs.totalPerTypes[2]+=1;
                continue;
            }
        }
        statistcs.totalTickets = acum;
        statistcs.average = statistcs.totalPrice/acum;        
    }

    function ShowTicketByAddress(address ad) public view{
        for(uint256 i = 0; i < userTickets[ad].length; i++){
            showTicket( userTickets[ad][i]);
        }
    }

    function ShowAllTickets() public view{
        for(uint256 i = 0 ; i<acum;i++){
            showTicket(i);
        }
    }

    function changeTicketOwner(uint256 ticketId,address newOwner) public{
        userTickets[newOwner].push(ticketId);
        uint256 currentId;
        for(uint256 i = 0; i<userTickets[msg.sender].length;i++){
            if(ticketId == userTickets[msg.sender][i]){
                currentId = i;
                break;
            }
        }
        uint256 aux = userTickets[msg.sender][userTickets[msg.sender].length];
        userTickets[msg.sender][currentId]=aux;
        userTickets[msg.sender].pop();
    }

    function TransferTicket(uint256 id,address newOwner) public payable IsTransferible(id)  EnoughtBalanceToTransfer(id) onlyOwner(id){
        address oldOwner = tickets[id]._owner();
        (bool success, ) = oldOwner.call{value: msg.value-ManageFee(id, oldOwner)}("");
        require(success == true, "Transaction failed!");
        tickets[id].changeOwner(newOwner);
        changeTicketOwner(id, newOwner);    

    }
    function calculateFee(uint256 id) public view returns(uint256){
        return ((tickets[id]._price() * fee)/100);
    }

    function ManageFee(uint256 id, address ticketOwner)public payable onlyOwner(id) returns(uint256){
        uint256 ticketFee =calculateFee(id);
        (bool success, ) = ticketOwner.call{value:ticketFee}("");
        require(success == true, "Transaction failed!");
        return ticketFee;
    }
    function ChangeTicketPrice(uint256 ticketId,uint256 newPrice) public {
        ManageFee(ticketId,msg.sender );
        tickets[ticketId].ChangePrice(newPrice);
    }
    function showTicket(uint256 index)public view returns(Ticket){
        return tickets[index];
    }
    function ShowStatistcs()public {
        totalValue();
        emit Statistcs(statistcs);       
    }

    function DeleteTicket(uint256 ticketId)public onlyOwner(ticketId){
        uint256 position;
        for(uint256 i; i< acum;i++){
            if(tickets[i]._ticketId() == ticketId){
                position = i;
                break;
            }              
        }
        tickets[position] = tickets[acum-1];
        tickets.pop();
        acum-=1;
        changeTicketOwner(ticketId,bault);
    }
}