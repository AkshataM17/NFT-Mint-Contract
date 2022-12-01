//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable{
    //whitelisted addresses should be able to mint 1 NFT
    //whitelisted should start 5 min before public sale

    string _baseTokenURI;
    IWhitelist whitelist;
    bool public presaleStarted;
    uint256 public maxTokenIds = 20;
    bool public _paused;
    uint256 public presaleEnded;
    uint256 public tokenIds;
    uint256 public price = 0.05 ether;

    modifier onlyWhenNotPaused {
        require(!_paused, "The contract is currently paused");
        _;
    }
    
    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD"){
     _baseTokenURI = baseURI;
     whitelist = IWhitelist(whitelistContract);
    }

    function pauseContract(bool pause) public onlyOwner{
       _paused = pause;
    }

    function startPresale() public onlyOwner{
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp <= presaleEnded, "Presale not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(maxTokenIds < tokenIds, "No more NFTs left");
        require(msg.value > price, "You don't have enough funds");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp > presaleEnded, "Public mint not running");
        require(msg.value > price, "Not enough eth");
        require(maxTokenIds < tokenIds, "No more NFTs left");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view virtual override returns (string memory){
        return _baseTokenURI;
    }

    function withdraw() public onlyOwner{
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent,) = _owner.call{value: amount}("");
        require(sent, "falied to send ether");
    }

    receive() external payable{}

    fallback() external payable{}

}