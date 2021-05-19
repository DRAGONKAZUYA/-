// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GanFan {
    struct Voter
    {
        uint VoteChance;    //投票者的票数
        bool GetTicket;     //是否已经得到初始票
    }
    struct Restaurant
    {
        uint Ticket;    //餐馆的得票数
        uint Funds;     //餐馆的资金
        uint Number;    //餐馆的编号
    }
    Restaurant[] restaurant;   //有五家餐馆可供选择
    mapping(address => Voter) public voters;    //将投票者的地址和投票者绑定
    function GetTickets() public {
        Voter storage sender=voters[msg.sender];
        require(sender.GetTicket!=true,"You have got ticket");
        sender.VoteChance=1;
        sender.GetTicket=true;
    }
    function Vote(uint Number,uint Ticket,uint Funds) public{
        Voter storage sender=voters[msg.sender];
        require(Ticket<=sender.VoteChance,"Do not have so much tickets");
        restaurant[Number].Ticket+=Ticket;
        restaurant[Number].Funds+=Funds;
    }
    function Delegate(address to) public{
        Voter storage sender=voters[msg.sender];
        require(sender.VoteChance>0,"You have no chance to vote");
        require(to!=msg.sender,"Self-Delegate is not allowed");
        Voter storage delegate_=voters[to];
        delegate_.VoteChance+=sender.VoteChance;
        sender.VoteChance=0;
    }
    function FinalChoice() public view returns (uint Place,uint Fund_Per_Person)
    {
        uint Max_Ticket=0;
        uint Max_Funds=0;
        uint Ticket_number=0;
        uint Total_funds=0;
        for(uint i=0;i<5;i++)
        {
            Ticket_number+=restaurant[i].Ticket;
            Total_funds+=restaurant[i].Funds;
            if(restaurant[i].Funds>Max_Funds)
            {
                Max_Funds=restaurant[i].Funds;
                Max_Ticket=restaurant[i].Ticket;
                Place=i;
            }
            else if(restaurant[i].Funds==Max_Funds)
            {
                if(restaurant[i].Ticket>Max_Ticket)
                {
                    Max_Ticket=restaurant[i].Ticket;
                    Place=i;
                }
            }
        }
        Fund_Per_Person=Total_funds/Ticket_number;
    }
}
