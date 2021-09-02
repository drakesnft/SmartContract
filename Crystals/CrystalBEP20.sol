// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;

import "./BEP20.sol";
import "../Game/ICrystalToken.sol";

contract CrystalBEP20 is BEP20, ICrystalToken {
    address public gameMaster;
    modifier onlyGameMaster() {
        require(msg.sender == gameMaster, "Only GameMaster can call this function");
        _;
    }

    constructor(string memory name, string memory symbol) BEP20(name, symbol) internal {
        gameMaster = msg.sender;
    }

    function setGameMaster(address _gameMaster) external onlyOwner {
        gameMaster = _gameMaster;
    }

    function mint(uint256 amount) external onlyGameMaster {
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) external override {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) external override {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
            amount, "Burn amount exceeds allowance"
        );

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }
}