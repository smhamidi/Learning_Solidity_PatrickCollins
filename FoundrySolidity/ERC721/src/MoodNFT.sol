// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    error MoodNFT__YouAreNotApprovedOrOwner();
    uint256 private s_tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;

    enum Mood {
        HAPPY,
        SAD
    }
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSVGImageURI,
        string memory happySVGImageURI
    ) ERC721("MoodNFT", "MN") {
        s_tokenCounter = 0;
        s_sadSVGImageURI = sadSVGImageURI;
        s_happySVGImageURI = happySVGImageURI;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenID
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenID] == Mood.HAPPY) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }
        string memory tokenMetaData = string.concat(
            '{"name":"',
            name(), // You can add whatever name here
            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
            imageURI,
            '"}'
        );

        return
            string.concat(
                _baseURI(),
                Base64.encode(bytes(abi.encodePacked(tokenMetaData)))
            );
    }

    function flipMood(uint256 tokenID) public {
        // only the owner or an approved user should be able to change the nft
        if (!_isApprovedOrOwner(msg.sender, tokenID)) {
            revert MoodNFT__YouAreNotApprovedOrOwner();
        } else if (s_tokenIdToMood[tokenID] == Mood.HAPPY) {
            s_tokenIdToMood[tokenID] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenID] = Mood.HAPPY;
        }
    }
}
