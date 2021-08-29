contract CryptoBank{
    
    address payable owner;
    mapping(address => uint256) public balances;
    address[] public Holders;
    address[] public ClossingAccountRequests;
    
    constructor(){
        owner = payable(msg.sender);
    }
    modifier OnlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    function OpenBank() public payable OnlyOwner(){
        require(msg.value >= 2 ether,"Invalid Ammount");
    }
    
    function CheckBalance()public view returns(uint256){
        return address(this).balance;
    }
    function CloseBank() public payable{
        
        owner.transfer(address(this).balance);
        
    }
    
    function OpenAccount()payable public {
        require(msg.value > 0, "Invalid Value");
        Holders.push(msg.sender);
        balances[msg.sender] = msg.value;
    }
    
    function Withdraw(uint256 Ammount) payable public{
        require(balances[msg.sender] > 0 ether && msg.value <= balances[msg.sender]  ,"Invalid Ammount");
        require(balances[msg.sender] >= Ammount,"Invalid AAmount");
        
        balances[msg.sender] -= Ammount;
        
        payable(msg.sender).transfer(Ammount);
    }
    
    function Bonus() public payable OnlyOwner {
        uint8 i;
        for( i=1;i<=5;i++){
            balances[Holders[i]] += 1 ether;
            payable(Holders[i]).transfer(1 ether);
        }
        
    }
    
    function ClossingAccountRequest() public returns(bool){
        ClossingAccountRequests.push(msg.sender);
        return true;
        
    }
    
    function ProccessingClosingRequests() public payable OnlyOwner(){
        uint i;
        for(i=1;i<= ClossingAccountRequests.length;i++){
            payable(ClossingAccountRequests[i]).transfer(balances[ClossingAccountRequests[i]].balance); // sir I'm doing something wrong here but I didn't understand.
            ClossingAccountRequests[i] = ClossingAccountRequests[ClossingAccountRequests.length-1];
            ClossingAccountRequests.pop();
        }
        
    }
    
    function ownerRe() view public returns(address){
        return owner;
    }
    
}
