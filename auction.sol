// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;


contract Auction{

    //declare the owner of the auction contract
    address payable public owner;
    // a dircription of the product being auctioned.Saved on IPFS and prsented as a hash 
    string public ipfsHash;
    //declare an enum State.Our auction can be at any point started,canceled,running or ended
    enum state{started,running,ended,canceled}
    //declare a variable of type State
    state public auctionState;
    //declare bids connecting bidders to the amount they bid
    mapping (address =>uint) public  bids;
    //declare the highest bid
    uint public highestBid;
    //declare the bidder with the highest bid.The address is payable incase the auction is canceled or he is outbid
    address payable public highestBidder;
    //start date
    uint public startBlock;
    uint public endBlock;
    uint increment= 1 ether;


    //Start the auction by initialising the owner and auction state
    constructor(address auctionOwner){
        owner=payable(auctionOwner);
        auctionState=state.running;

        /*we know that the block time of ethereum is every 15 secs
        so we can use the block number to estimate the time between the start and end of the auction*/
        startBlock=block.number;

        /*the auction will run for 1 week
        so we get the end block by dividing the number of blocks made in a week by 15
        */
        endBlock=startBlock+3;

        ipfsHash="";

    }

    modifier restricted(){
        require(msg.sender==owner);
        _;

    }

    //decalre a modifier that makes sure the auction is running between the start and end blocks

    modifier withinTimeLimit(){
        require(block.number>=startBlock);
        require(block.number<=endBlock);
        require(auctionState==state.running);
        _;
    }

//returns the smaller of 2 numbers
    function min(uint a, uint b) pure internal returns(uint){

        if (a<=b){
            return a;
        }

        else {
            return b;
        }

    }

    
    //Allows anyone (except owner) to send eth to the contract and place a bid
    function placeBid() public payable withinTimeLimit returns(bool){
        require(auctionState==state.running);
        //make sure the bidder is not the owner
        require(msg.sender!=owner,"Owner cannot make a bid");
        require(msg.value>=increment,"Your bid is too low ");
        


        uint currentBid= bids[msg.sender]+msg.value;
        require(currentBid>highestBid);
        //update the bids mapping
        bids[msg.sender]=currentBid;

        if (currentBid<=bids[highestBidder]){
          highestBid=min(currentBid+increment, bids[highestBidder]);  

        }
        else{
            highestBid=min(currentBid, bids[highestBidder] +increment);  

            //set the address of the bidder to highest bidder
        highestBidder=payable(msg.sender);

        }
       
        return true;
    }


    //end the auction.The auction can be ended by any bidder or the owner
    function finaliseAuction() public {
        //the auction time must be finished and the state of the auction must be canceled
        require(auctionState==state.canceled || block.number>endBlock);
        require(msg.sender==owner|| bids[msg.sender]>0,"You cannot finalise the auction again");

        address payable recipient;
        uint value;


        //if auction is canceled all bidders get heir funds back
        if(auctionState ==state.canceled){

            recipient=payable(msg.sender);
            value=bids[msg.sender];
        }
        //if auction is ended the owner gets the highest bid money and everyone gets their funds back
        else if(auctionState ==state.ended){

           
            if(msg.sender==owner){//this is the owner
                
                recipient= owner;
                value=highestBid;
           
            }

            else{//this is a bidder

                if(msg.sender==highestBidder){//the highest bidder ; auction winner
                    recipient=highestBidder;
                    value=bids[highestBidder]-highestBid;

                }

                else{ //all the other bidders

                        recipient=payable(msg.sender);
                        value=bids[msg.sender];



                }

           

            }

        }

        recipient.transfer(value);
        bids[recipient]=0;
            

    }

    function cancelAuction() public restricted{
        auctionState=state.canceled;
    }

     function endAuction() public restricted{
        auctionState=state.ended;
    }

   


}



/*Declare a contract that deploys an instance of the auction contract
this allows users to deploy multiple instance of the contract and be the owner of their own auction
the user will pay to deploy the contract*/
contract auctionCreator{

    //The admin
    address public admin;

    //an array to keep the contract adddress
    Auction[] public deployedAuctions;

    constructor(){
        admin=msg.sender;
    }

    //Create an instance of the auction contract
    function startAuction() public {
     Auction newAuctionAddress= new Auction (msg.sender);  
     deployedAuctions.push(newAuctionAddress);
    }


}