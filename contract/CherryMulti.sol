pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "./interface/IERC20.sol";
import "./interface/IUniswapV2Router01.sol";
import "./interface/ILendingPool.sol";

contract CherryMulti{
    mapping (address => bool) public managers;
    uint public MIN_SIGNATURES;
    uint public transactionIdx;
    address private ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    ICreator creator;
    struct Transaction {
        bool status;
        address token;
        address from;
        address to;
        uint amount;
        bool goal;  //true: add manager ,false:remove manager 
        uint8 kind; //5:lending  4:addLiquidity 3: manage 2:signature 1:transaction
        uint newMinSignatures;
        uint8 signatureCount;
        
        address secToken;
        uint secAmount;
    }
    
    mapping (uint => mapping(address => bool)) public signatures;
    mapping (uint => Transaction) public transactions;
    uint[] public pendingTransactions;
    
    modifier isManager{
        require(managers[msg.sender] == true);
        _;
    }
    
    constructor(uint _minSignCount,address[] memory _managers,address _creator) public{
        creator = ICreator(_creator);
        MIN_SIGNATURES = _minSignCount;
        for(uint i = 0; i < _managers.length; i++){
            managers[_managers[i]] = true;
        }
    }
    
    event DepositFunds(address from, uint amount);
    event TransferFunds(address to, uint amount);
    event TransactionCreated(
        address from,
        uint transactionId
    );
    
    event SignatureChanged(
        uint signatureOld,
        uint signature,
        uint transactionId
    );
    
    event ManagerChanged(
        address account,
        bool goal,
        uint transactionId
    );

    function receive() public payable{
        emit DepositFunds(msg.sender, msg.value);
    }
    
    function withdraw(uint amount) isManager public{
        creatTransaction(ETH_ADDR, msg.sender, amount);
    }
    
    function creatTransaction(address token, address to, uint amount) isManager public{
        require(address(0) != msg.sender);
        if(token == ETH_ADDR){
            require(address(this).balance >= amount);
        }
        if(token != ETH_ADDR){
            require(IERC20(token).balanceOf(address(this)) >= amount);
        }
   
        uint transactionId = transactionIdx++;
        Transaction memory transaction;
        transaction.status = false;
        transaction.token = token;
        transaction.from = address(this);
        transaction.to = to;
        transaction.amount = amount;
        transaction.signatureCount = 0;
        transaction.kind = 1;
        transactions[transactionId] = transaction;
        pendingTransactions.push(transactionId);
        emit TransactionCreated(msg.sender,transactionId);
    }
    
    function signTransaction(uint transactionId) public isManager{
        Transaction storage transaction = transactions[transactionId];
        require(address(0) != msg.sender);
        require(true != transaction.status);
        require(signatures[transactionId][msg.sender]!=true);
        signatures[transactionId][msg.sender] = true;
        transaction.signatureCount++;
        
        //transaction
        if(transaction.kind == 1 && transaction.signatureCount >= MIN_SIGNATURES){
            if(transaction.token == ETH_ADDR){
                require(address(this).balance >= transaction.amount);
                payable(transaction.to).transfer(transaction.amount);
            }
            if(transaction.token != ETH_ADDR){
                require(IERC20(transaction.token).balanceOf(address(this)) >= transaction.amount);
                IERC20(transaction.token).transfer(transaction.to, transaction.amount);
            }
            
            transaction.status = true;
            emit TransferFunds(transaction.to, transaction.amount);
        }
        //signature
        if(transaction.kind == 2 && transaction.signatureCount >= MIN_SIGNATURES){
            uint older = MIN_SIGNATURES;
            MIN_SIGNATURES = transaction.newMinSignatures;
            transaction.status = true;
            emit SignatureChanged(older,MIN_SIGNATURES,transactionId);
        }
        
