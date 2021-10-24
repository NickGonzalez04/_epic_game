//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Imports
// ERC721 standards contract
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// standards helper functions.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Hardhat's import to console.log wihtin contract.
import "hardhat/console.sol";

// Libraries
import './libraries/Base64.sol';

contract EpicGame is ERC721 {

    /// @notice - Character structure 
    struct CharAttributes {
        uint characterIndex;
        string name;
        string imgURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    // tokenId
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Array of character structs
    CharAttributes[] defaultChars;

    // mapping from _tokenId => character attributes.
    mapping(uint256 => CharAttributes) public tokenHolderAttributes;

    // Villan Attributes
    struct Villan {
        string name;
        string imgURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    Villan public villan;
    // mapping address => _tokenId (storing owner of token to reference from storage).
    mapping(address => uint256) public tokenHolder;

    /// @dev when NFT is requested it will be given it's attributes.
    /// Then will iterate through characters saving their values
    /// within the contract. Will be used when minting NTFs.
    constructor(
        string[] memory characterNames,
        string[] memory characterImgURIs,
        uint[] memory characterHp,
        uint[] memory charAttackDmg,
        string memory villanName,
        string memory villanImgURI,
        uint villanHp,
        uint villanAttackDmg
        )
        ERC721("Heros", "HERO")
        {

            villan = Villan({
                name: villanName,
                imgURI: villanImgURI,
                hp: villanHp,
                maxHp: villanHp,
                attackDamage: villanAttackDmg
            });
        
        console.log("Done initializing Villan - %s w/ Hp %s, img %s", villan.name,villan.hp, villan.imgURI);

        for(uint i = 0; i < characterNames.length; i += 1) {
            defaultChars.push(CharAttributes({
                characterIndex: i,
                name: characterNames[i],
                imgURI: characterImgURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: charAttackDmg[i]
            }));

            CharAttributes memory char = defaultChars[i];
            console.log("Done initialzing - %s HP %s, img %s", char.name, char.hp, char.imgURI);
         }

        // Increment _tokenId
        _tokenIds.increment();
        }

        // Function that mints selected character NFT
        function mintCharacterNFT(uint _characterIndex) external {

            uint newTokenId = _tokenIds.current();

            // Minting tokenId to users address
            _safeMint(msg.sender, newTokenId);

                // Holding metadata to token holders character
                tokenHolderAttributes[newTokenId] = CharAttributes({
                characterIndex: _characterIndex,
                name: defaultChars[_characterIndex].name,
                imgURI: defaultChars[_characterIndex].imgURI,
                hp: defaultChars[_characterIndex].hp,
                maxHp: defaultChars[_characterIndex].hp,
                attackDamage: defaultChars[_characterIndex].attackDamage
                });

            console.log("Minted NFT with tokenId %s and characterIndex %s", newTokenId, _characterIndex);

            tokenHolder[msg.sender] = newTokenId;

            _tokenIds.increment();
        }

        // 
        function tokenURI(uint256 _tokenId) public view override returns (string memory) {
            // retrieve requested token by ID
            CharAttributes memory cAttributes = tokenHolderAttributes[_tokenId];

            // setting attribute integers to string format
            string memory strHp = Strings.toString(cAttributes.hp);
            string memory strmaxHp = Strings.toString(cAttributes.maxHp);
            string memory strattackDmg = Strings.toString(cAttributes.attackDamage);

            // encode character to Base64 to follow metadata standards
            string memory jsonMeta = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "',
                            cAttributes.name,
                            ' --- NFT #: ',
                            Strings.toString(_tokenId),
                            '", "description": "This is an NFT that lets people play Metaslayer Dual!", "image": "',
                            cAttributes.imgURI,
                                '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strmaxHp,'}, { "trait_type": "Attack Damage", "value": ',
                            strattackDmg,'} ]}'
                            )
                        )
                    )
                );


                // sets metadata to base64 string (packing it all together) under unqiue string
                string memory output = string(abi.encodePacked("data:application/json;base64,",jsonMeta));

                return output;
                
        }
}