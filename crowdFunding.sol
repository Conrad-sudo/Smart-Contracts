// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;


contract crowdFunding{

    address public admin;
    //declare contributors who will fund the project
    mapping(address=>uint) public contributors;

    uint public numOfContributors;
    uint public minContribution;
    uint public deadline; //timestamp
    //target amount of money to be raised by the campaign
    uint public goal;
    uint public raisedAmount;
    //declare a strct that stores info about the spending request generated by the admin
    struct Request{
        string description;
        address payable recipient;
        uint value ;
        mapping(address=>bool) votes;
        uint numOfVoters;
        bool completed;
    }

    mapping(uint=>Request) public requests;
    uint public numOfRequests;






    constructor (address campaigner,uint _goal, uint _deadline){

        admin=campaigner;
        goal=_goal;
        deadline=block.timestamp+_deadline;
        minContribution =1 ether;


    }

    //events used to send messages to external interfaces listening for them in order to update the interface
    event ContributionMade(address sender, uint value);
    event RequestCreated(string description,address recipeint, uint value);
    event PaymentMade(address recipeint , uint value);

    //allows contributors to send money to the contract
    function contribute() public payable{
        require(msg.value>=minContribution,"Minimum contribution not met");
        require(block.timestamp<deadline,"Deadline has passed");

        //first time cotributor
        if( contributors[msg.sender]==0){
            
            numOfContributors++;

        }

         //add to contributors mapping
        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
        emit ContributionMade(msg.sender,msg.value);


    } 


    receive() external payable{

        contribute();
    }

    //retreive the contract balance
    function getBalance() public view returns(uint){

        return address(this).balance;
    }



    //Allows the contributors to get a refund
    function getRefund()public {
        require(block.timestamp> deadline&&raisedAmount<goal);
        require(contributors[msg.sender]>0,"You cannot request for a refund");

        address payable recepient= payable(msg.sender);

        recepient.transfer(contributors[recepient]);
        contributors[recepient]=0;
        
    }


    //allows admin to create a spending request
    function createRequest(string memory  _description, address payable _recepient ,uint _value) public restricted {

            //create a new instance of Request state and save it to the requests mapping
            Request storage newRequest =requests[numOfRequests];
            numOfRequests++;


            //asign values to the structure
            newRequest.description=_description;
            newRequest.recipient=_recepient;
            newRequest.value=_value ;
            newRequest.completed=false;
            newRequest.numOfVoters=0;

            emit RequestCreated(_description,_recepient,_value);


    }


    //allows contributors to vote on a spending request
    function vote(uint requestIndex)public {

        require(contributors[msg.sender]>0,"You cannot vote");
        require(requests[requestIndex].completed==false,"Voting is complete");
        
        //this must be specifically implied for structs
        Request storage thisRequest= requests[requestIndex];
        require(thisRequest.votes[msg.sender]==false,"You have already voted");

        thisRequest.votes[msg.sender]=true;
        thisRequest.numOfVoters++;

    }


    /*Allows the admin to make a payment to a vendor
    The admin can only make a payment if more than 50% of the contributors voted for the payment request*/
    function makePayment(uint requestIndex)public restricted{

        require(raisedAmount>=goal,"Goal has not been reached");
        Request storage thisRequest= requests[requestIndex];
        require(thisRequest.numOfVoters>=numOfContributors/2," You don't have enough votes to make a payment" );
        require(thisRequest.completed==false,"This request has already been completed");

        //transfer funds to vendor
        thisRequest.recipient.transfer(thisRequest.value);

        
        //set the payment request to completed
        thisRequest.completed=true;

        emit PaymentMade(thisRequest.recipient,thisRequest.value);

    }



    modifier restricted( ){

        require(msg.sender==admin,"Admin access only");
        _;

    }


    


}




//Contract allows a user to launch an instance of their own crowdfunding project

contract crowdFundManger{

    address public owner;
    //an array to keep the crowdfunding project addresses
    crowdFunding[] public campaigns;

    constructor (){
        owner=msg.sender;
    } 


    function stratCrowdFunding(uint _goal, uint deadline)public{

        crowdFunding newCampaign = new crowdFunding(msg.sender,_goal,deadline);
        campaigns.push(newCampaign);
    }

}