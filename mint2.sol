// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/security/Pausable.sol";
import "@openzeppelin/contracts@4.6.0/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
contract Aiverse is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, AccessControl {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC721("aiverse", "AVS") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
    }
    uint256 public totalsupply = 35;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address payable to, string memory tokenURi)
        public virtual payable
    {
        require(msg.value >= 1, "Not enough ETH sent; check price!");
        require(totalsupply>0 ,"limit exceeded");
        _tokenIds.increment();
        totalsupply -= 1;

        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);
        _setTokenURI(newItemId , tokenURi);
    }
    function withdrawal(uint256 amnt)
    public payable onlyRole(DEFAULT_ADMIN_ROLE)
    {
        address payable recipient= payable(msg.sender);
        recipient.transfer(amnt);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
