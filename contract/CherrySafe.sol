// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./CherryMulti.sol";

contract CherrySafe {
    
    using Set for Set.Address;
    address private owner;
    mapping(address => Set.Address) private userMultiSign;
    mapping(address => bool) private approved;
    address[] private multiSignArray;
    address private uniswapFactory;
    address private uniswapRouter;
    address private lengdingPool;
    modifier onlyMultiSign{
        require(approved[msg.sender] == true);
        _;
    }
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    constructor(address _owner) public{
        owner = _owner;
    }

    function creatNewMultiSign(uint _minSignCount, address[] memory _managers) public returns(bool) {
        require(msg.sender != address(0),"zero address!");
        address newAddress = address(new MultiSign(_minSignCount, _managers,address(this)));
        approved[newAddress] = true;
        for(uint i = 0; i < _managers.length; i++){
            userMultiSign[_managers[i]].add(newAddress);
        }
        multiSignArray.push(newAddress);
        return true;
    }
    
    function setFactory(address _factory) onlyOwner external returns(bool){
        uniswapFactory = _factory;
        return true;
    }
    
    function setRouter(address _router) onlyOwner external returns(bool){
        uniswapRouter = _router;
        return true;
    }
    
    function setLending(address _lending) onlyOwner external returns(bool){
        lengdingPool = _lending;
        return true;
    }
    
    function factory() public view returns(address){
        return uniswapFactory;
    }
    
    function router() public view returns(address){
        return uniswapRouter;
    }
    
    function lending() public view returns(address){
        return lengdingPool;
    }
    
    function getMultiSignAddr(address _account,uint _index) public view returns(address){
        return userMultiSign[_account].at(_index);
    }
    
    function getLimitedNumber(address _account) public view returns(uint){
        return userMultiSign[_account].length();
    }
    
    function ifLimited(address _account, address _addr) public view returns(bool){
        return userMultiSign[_account].contains(_addr);
    }
    
    function removeLimited(address _account, address _addr) public onlyMultiSign{
        userMultiSign[_account].remove(_addr);
    }
    
    function addLimited(address _account, address _addr) public onlyMultiSign{
        userMultiSign[_account].add(_addr);
    }
    
    function getAddrByIndex(uint _index) public view returns(address){
        return multiSignArray[_index];
    }
    
    
    
    function getArrayLength() public view returns(uint){
        return multiSignArray.length;
    }
    
    function changeOwner(address _newOwner) external {
        require(msg.sender == owner);
        owner = _newOwner;
    }
    
}

