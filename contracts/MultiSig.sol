// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "/DudleToken.sol";

contract MultiSig is DudleToken {
    struct Pool {
        mapping(address => bool) voter;
        uint256 voteNumber;
    }
    
    mapping(address => Pool) pools;
    
    //Only owners are able to vote to send tokens to address
    function vote (address _addr, uint256 tokenAmount) public onlyOwner {
        require(!pools[_addr].voter[msg.sender], "this address already voted");
        pools[_addr].voteNumber++;
        pools[_addr].voter[msg.sender] = true;
        if (pools[_addr].voteNumber > owners.length / 2) {
            //mint tokens to address
            
            mint(_addr, tokenAmount);
            
            pools[_addr].voteNumber = 0;
            for (uint256 i = 0; i < owners.length; i++) {
                delete pools[_addr].voter[owners[i]];
            }
        }
    }
}