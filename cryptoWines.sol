// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract cryptoWines is ERC721URIStorage, Ownable(msg.sender){
    
    event NftBought(address _seller, address _buyer, uint256 _price);
    
    mapping(uint256 _tokenId => uint256 _price ) public tokenIdToPrice;
    uint256 nextIdToMint;

   //CONSTRUCTOR
    constructor() ERC721("CryptoWines", "CWN"){}
   

///////////////////
    //@title setPrice
    //@notice This function set permit to set the price of an NFT
    //@dev require verify the owner of the NFT
    function setPrice(uint256 _tokenId, uint256 _price) external {
        require(msg.sender == ownerOf(_tokenId), "Not owner of this token");
        tokenIdToPrice[_tokenId] = _price;
    }

    //title mint
    //@notice with this function the vineyard mint the nft that he want to sale
    function mint(address vOwner, uint256 _tokenId, string calldata _uri) external onlyOwner {
        vOwner = msg.sender;
        _mint(vOwner, _tokenId); 
        _setTokenURI(_tokenId, _uri);
    }
    //@title buy
    //@notice Permit to buy a Cryptowine with ether
    function buy(uint256 _tokenId) external payable {
        uint256 price = tokenIdToPrice[_tokenId];
        require(price > 0, "This token is not for sale");
        require(msg.value == price, "Incorrect value");
        address seller = ownerOf(_tokenId);
        payable(seller).transfer(msg.value);
        tokenIdToPrice[_tokenId] = 0;
        /*_mint(msg.sender, nextIdToMint); 
        nextIdToMint ++;*/
        emit NftBought(seller, msg.sender, price);
    }
//////////////////////
    //#title trnasferNFT
    //@notice Allow an owner to transfer his nft to somebody
    function transferNFT(address from, address to, uint256 tokenId) external {
        require(ownerOf(tokenId) == from, "Sender is not the owner");
        safeTransferFrom(from, to, tokenId);
    }


    //@title withdraw
    //@notice Allow the owner to withdraw the money in the smartcontract
    function withdraw() external onlyOwner{
         (bool callSuccess, /*bytes memory dataReturned*/) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

}
