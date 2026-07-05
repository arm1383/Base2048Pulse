// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Base2048Pulse {
    error NotOwner();
    error GamePaused();
    error ScoreTooLow();
    error ScoreNotImproved();
    error InvalidAddress();
    error InvalidIndex();
    error NoDirectPayments();

    struct ScoreEntry {
        address player;
        uint256 score;
        uint256 updatedAt;
    }

    uint256 public constant MAX_TOP_ENTRIES = 10;

    address public owner;
    bool public paused;
    uint256 public immutable minimumSubmitScore;
    uint256 public totalUniquePlayers;
    uint256 public totalAcceptedSubmissions;

    mapping(address => uint256) public playerBestScore;
    mapping(address => uint256) public playerLastPlayedAt;

    ScoreEntry[MAX_TOP_ENTRIES] private topEntries;
    uint256 private topEntryCount;

    event ScoreSubmitted(address indexed player, uint256 score, uint256 previousBest, uint256 timestamp);
    event PauseStatusChanged(bool isPaused);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(uint256 initialMinimumSubmitScore) {
        owner = msg.sender;
        minimumSubmitScore = initialMinimumSubmitScore;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    receive() external payable {
        revert NoDirectPayments();
    }

    fallback() external payable {
        revert NoDirectPayments();
    }

    function submitScore(uint256 score) external {
        if (paused) revert GamePaused();
        if (score < minimumSubmitScore) revert ScoreTooLow();

        uint256 previousBest = playerBestScore[msg.sender];
        if (score <= previousBest) revert ScoreNotImproved();

        if (previousBest == 0) {
            totalUniquePlayers += 1;
        }

        playerBestScore[msg.sender] = score;
        playerLastPlayedAt[msg.sender] = block.timestamp;
        totalAcceptedSubmissions += 1;

        _updateLeaderboard(msg.sender, score, block.timestamp);

        emit ScoreSubmitted(msg.sender, score, previousBest, block.timestamp);
    }

    function setPaused(bool status) external onlyOwner {
        paused = status;
        emit PauseStatusChanged(status);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert InvalidAddress();
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }

    function getTopEntries() external view returns (ScoreEntry[] memory entries) {
        entries = new ScoreEntry[](topEntryCount);
        for (uint256 i = 0; i < topEntryCount; i++) {
            entries[i] = topEntries[i];
        }
    }

    function getTopEntry(uint256 index) external view returns (ScoreEntry memory) {
        if (index >= topEntryCount) revert InvalidIndex();
        return topEntries[index];
    }

    function getEntryCount() external view returns (uint256) {
        return topEntryCount;
    }

    function getPlayerBestScore(address player) external view returns (uint256) {
        return playerBestScore[player];
    }

    function _updateLeaderboard(address player, uint256 score, uint256 updatedAt) internal {
        bool found;
        uint256 existingIndex;

        for (uint256 i = 0; i < topEntryCount; i++) {
            if (topEntries[i].player == player) {
                found = true;
                existingIndex = i;
                break;
            }
        }

        if (found) {
            for (uint256 i = existingIndex; i + 1 < topEntryCount; i++) {
                topEntries[i] = topEntries[i + 1];
            }
            delete topEntries[topEntryCount - 1];
            topEntryCount -= 1;
        }

        uint256 insertIndex = topEntryCount;
        for (uint256 i = 0; i < topEntryCount; i++) {
            if (score > topEntries[i].score) {
                insertIndex = i;
                break;
            }
        }

        if (topEntryCount < MAX_TOP_ENTRIES) {
            for (uint256 i = topEntryCount; i > insertIndex; i--) {
                topEntries[i] = topEntries[i - 1];
            }
            topEntries[insertIndex] = ScoreEntry(player, score, updatedAt);
            topEntryCount += 1;
            return;
        }

        if (insertIndex == topEntryCount) {
            return;
        }

        for (uint256 i = MAX_TOP_ENTRIES - 1; i > insertIndex; i--) {
            topEntries[i] = topEntries[i - 1];
        }
        topEntries[insertIndex] = ScoreEntry(player, score, updatedAt);
    }
}
