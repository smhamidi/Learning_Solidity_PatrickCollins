// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    // each NFT is actually a contract address and a token ID, because a contract
    // can mint any number of token for that nft and we specify each of them by token indexed

    uint256 private s_tokenCounter;
    mapping(uint256 => string) s_tokenIdToURI;

    constructor() ERC721("Cutie", "CAT") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToURI[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    /**A Uniform Resource Identifier (URI) is a string of characters that identifies
     *  a particular resource, often used to locate web resources.
     *  In the context of Solidity and ERC721, a URI is used to point to a resource
     *  that provides metadata about a specific non-fungible token, such as its name,
     *  description, and image. */
    function tokenURI(
        uint256 tokenID
    ) public view override returns (string memory) {
        return s_tokenIdToURI[tokenID];
    }
}
