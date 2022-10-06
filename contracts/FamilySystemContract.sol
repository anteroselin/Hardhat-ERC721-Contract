// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract FamilySystemContract is ERC721 {
  struct character {
    string name;
    uint8 gender;
    uint256 fatherId;
    uint256 motherId;
  }
  
  mapping (uint256 => character) public characters;
  uint256 public count;

  constructor() ERC721("Family System", "FS") {
    count = 0;
  }

  function createCharacter(string memory name, uint8 gender) external {
    characters[++count] = character(name, gender % 2, 0, 0);
  }
  
  function createChild(uint256 motherId, uint256 fatherId, string memory childName) external {
    require(characters[motherId].gender != characters[fatherId].gender, "gender can't be same");
    uint8 gender = 0;
    if ((motherId + fatherId) % 2 == uint256(0)) gender = 1;
    characters[++count] = character(childName, gender, fatherId, motherId);
  }

  function renameCharacter(uint256 characterId, string memory newName) external {
    characters[characterId].name = newName;
  }

  function getParents(uint256 characterId) external view returns(character memory, character memory) {
    character storage cur = characters[characterId];
    return (characters[cur.fatherId], characters[cur.motherId]);
  }

  function getMyChildren(uint256 characterId) external view returns(character[] memory) {
    uint256 childCount = 0;
    for (uint256 i = 1; i <= count; i++) {
      if (characters[i].fatherId == characterId || characters[i].motherId == characterId) {
        childCount++;
      }
    }
    character[] memory children = new character[](childCount);
    uint256 j = 0;
    for (uint256 i = 1; i <= count; i++) {
      if (characters[i].fatherId == characterId || characters[i].motherId == characterId) {
        children[j++] = characters[i];
      }
    }
    return children;
  }

  function getOurChildren(uint256 fatherId, uint256 motherId) external view returns(character[] memory) {
    uint256 childCount = 0;
    for (uint256 i = 1; i <= count; i++) {
      if (characters[i].fatherId == fatherId && characters[i].motherId == motherId ||
          characters[i].fatherId == motherId && characters[i].motherId == fatherId) {
        childCount++;
      }
    }
    character[] memory children = new character[](childCount);
    uint256 j = 0;
    for (uint256 i = 1; i <= count; i++) {
      if (characters[i].fatherId == fatherId && characters[i].motherId == motherId ||
          characters[i].fatherId == motherId && characters[i].motherId == fatherId) {
        children[j++] = characters[i];
      }
    }
    return children;
  }
}