// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LK99 is ERC20, ERC20Burnable, Ownable {
    mapping(uint256 => Proposal) private _proposals;

    struct Proposal {
        string description;
        uint256 voteCount;
    }

    uint256 private _nextProposalId = 1;

    constructor() ERC20("LK99", "LK99") {
        _mint(msg.sender, 99000000000000 * (10 ** uint256(decimals())));
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
    }

    function createProposal(string calldata description) public onlyOwner returns (uint256) {
        _proposals[_nextProposalId] = Proposal(description, 0);
        return _nextProposalId++;
    }

    function vote(uint256 proposalId) public {
        require(keccak256(abi.encodePacked(_proposals[proposalId].description)) != keccak256(abi.encodePacked("")), "ERC20: proposal does not exist");
        _proposals[proposalId].voteCount += balanceOf(msg.sender);
    }

    function getProposal(uint256 proposalId) public view returns (string memory description, uint256 voteCount) {
        require(keccak256(abi.encodePacked(_proposals[proposalId].description)) != keccak256(abi.encodePacked("")), "ERC20: proposal does not exist");
        return (_proposals[proposalId].description, _proposals[proposalId].voteCount);
    }
}

