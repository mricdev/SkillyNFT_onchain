// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "github.com/Brechtpd/base64/base64.sol";

contract NFTeam is ERC721Enumerable, Ownable {
  using Strings for uint256;
  
   struct Nft { 
      string name;
      string description;
      string bgHue;
   }
   
   mapping (uint256 => Nft) public nfts;
  
  constructor() ERC721("Skill Pulse 2021", "SKP21") {mint(6);}

  // public
  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(_mintAmount > 0);
    require(supply + _mintAmount <= 6);
    
    
// il faudrait ne permettre qu'owner de mint avec function() onlyOwner
    if (msg.sender != owner()) {
      require(msg.value >= 0.005 ether);
    }

// avec incrémenter de 1 à chaque mint en fonction du _mintAmount
    for (uint256 i = 1; i <= _mintAmount; i++) {
        Nft memory newNft = Nft(
        string(abi.encodePacked('SKP2021 #', uint256(supply + i).toString())), 
        "Skill Pulse V1 Team project",
        randomNum(361, block.difficulty, supply + i).toString());
        nfts[supply + i] = newNft;
        _safeMint(msg.sender, supply + i);
    }
  }

  function randomNum(uint256 _mod, uint256 _seed, uint _salt) public view returns(uint256) {
      uint256 num = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
      return num;
  }
  
  // lien entre le mapping et _tokenID
  function buildImage(uint256 _tokenId) public view returns(string memory) {
      Nft memory currentNft = nfts[_tokenId];
      return Base64.encode(bytes(
          abi.encodePacked(
              '<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg">',
              '<rect height="600" width="600" fill="hsl(',currentNft.bgHue,', 100%, 85%)"/>',
              '<polygon points="204.3876953125,117.26956176757812 238.341552734375,83.0543212890625 364.366455078125,83.0543212890625 395.6123046875,116.99137878417969 296.9448547363281,255.66043090820312 " fill="#ffffff"/>',
              '<path d="m361.3113,90.00864l25.34385,27.53909l-89.57143,125.94264l-83.73887,-125.38629l27.91296,-28.16497l120.05349,0m6.1103,-13.83909l-131.99634,0l-39.92525,40.33503l101.30598,151.46497l107.69402,-151.46497l-37.0784,-40.33503l0,0z" fill="#282695"/>',
              '<path d="m301.45814,201.13859c-11.31794,0 -21.45548,-0.90406 -30.20432,-2.64264s-17.56711,-5.07665 -26.31595,-9.94467l0,-29.34721l25.89934,0l2.84684,15.09086c2.01362,1.87766 5.62425,3.40761 10.83189,4.72893c5.13821,1.25178 10.83189,1.87766 16.94219,1.87766c4.23555,0 7.84618,-0.41726 10.69302,-1.25178c2.84684,-0.83452 5.06877,-2.08629 6.52691,-3.75533c1.45814,-1.66904 2.22193,-3.61624 2.22193,-5.98071c0,-2.22538 -0.69435,-4.24213 -2.08306,-5.98071c-1.3887,-1.73858 -3.61063,-3.40761 -6.73522,-5.00711c-3.12458,-1.59949 -7.36013,-3.19898 -12.63721,-4.86802c-11.94286,-3.12944 -21.73322,-6.25888 -29.3711,-9.45787c-7.63787,-3.19898 -13.33156,-7.02386 -17.08106,-11.40508c-3.7495,-4.38122 -5.62425,-9.87513 -5.62425,-16.41218c0,-6.25888 2.22193,-11.75279 6.59635,-16.41218c4.37442,-4.65939 10.48472,-8.34518 18.19203,-11.05736c7.70731,-2.71218 16.52558,-4.10305 26.45482,-4.24213c11.31794,-0.20863 21.38605,0.69543 30.13488,2.78173c8.74884,2.01675 16.45615,5.14619 23.12193,9.24924l0,27.26091l-24.85781,0l-3.88837,-15.16041c-2.15249,-0.90406 -5.27708,-1.66904 -9.30432,-2.43401c-4.02724,-0.69543 -8.26279,-1.11269 -12.84551,-1.11269c-3.88837,0 -7.36013,0.41726 -10.34585,1.25178c-3.05515,0.83452 -5.41595,2.08629 -7.15183,3.75533c-1.73588,1.66904 -2.63854,3.75533 -2.63854,6.18934c0,2.01675 0.76379,3.82487 2.22193,5.42437c1.45814,1.59949 4.02724,3.12944 7.77674,4.72893c3.68007,1.59949 8.88771,3.40761 15.48405,5.49391c15.83123,3.75533 27.84352,8.48426 36.03688,14.1868c8.19336,5.70254 12.29003,13.35228 12.29003,23.08832c0,6.67614 -2.22193,12.37868 -6.66578,17.03807c-4.44385,4.65939 -10.69302,8.27563 -18.67807,10.70964c-7.98505,2.36447 -17.28937,3.61624 -27.84352,3.61624z" fill="#282695"/>',
              '<text text-anchor="middle" font-family="Faustina" font-size="24" y="80%" x="50%" fill="#000000">juillet 2021 \xF0\x9F\x9A\x80</text>',
              '<text text-anchor="middle" font-family="Faustina" font-size="48" y="65%" x="50%" fill="#000000">Skill Pulse v1</text>',
              '</svg>'
          )
      ));
  }

  function tokenURI(uint256 _tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(_tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    Nft memory currentNft = nfts[_tokenId];
     
      return string(abi.encodePacked(
              'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
                          '{"name":"',currentNft.name,'","description":"',currentNft.description,'", "image": "', 
                          'data:image/svg+xml;base64,', 
                          buildImage(_tokenId),
                          '"}')))));
  }
}
