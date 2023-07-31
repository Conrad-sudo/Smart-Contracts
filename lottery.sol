// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;


contract Lottery{


    address public manager;
    address  payable[] public players;



    //Initialise the owner
    constructor(){

        manager=msg.sender;
        //Automatically add the manger to the contract
        players.push(payable(manager));

    }


// Get the player address and save it to the players array
//msg.value is a global variable that represents the value of wei sent to a contract in a transaction
    receive() external payable{

        require(msg.sender !=manager,"The manger cannot enter the lottery");
        require(msg.value>= 0.1 ether,"The bid is not enough to enter the lottery");
        
        players.push(payable(msg.sender));


    }


//Get the contract balance
    function getBalance() public view returns(uint){

        require(msg.sender==manager,"Only the manager can see the contract balance");
        return address(this).balance;
    }




    function transferEth(uint playerIndex) private returns(address payable )  {
        
        uint currentBalance= getBalance();
        players[playerIndex].transfer(currentBalance);
        return players[playerIndex];
        

        
    }


    function pickWinner()public  {

        //uint arrayLength=players.length;

        //require(msg.sender==manager );
        require (players.length>=10);

        //manager gets  10%
        players[0].transfer(getBalance()/10);


        uint randomNumber=random();
        uint index= randomNumber%players.length;
        address payable winner= players[index];
        winner.transfer(getBalance()); 

        /*initialise the players state varibale to an empty in-memory dynamic array
        the 0 indicates the size of the dynamic array
        thus ressting the lottry*/
        players= new address payable[](0);

       
    }



    //Generates and returns a random number
    function random() private view returns(uint){

        // because the blockchain is always growing the asrguments given will give sufficiently random number
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
       
    }


  


   


}