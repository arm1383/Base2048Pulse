// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Base2048Pulse {
    error NotOwner();
    error GamePaused();
    error InvalidAddress();
    error InvalidIndex();
    error NoDirectPayments();

    struct ScoreEntry {
        address player;
        uint256 score;
        uint256 updatedAt;
    }

    struct ScoreSubmission {
        uint256 submissionId;
        address player;
        uint256 score;
        uint256 timestamp;
    }

    uint256 public constant MAX_TOP_ENTRIES = 10;

    address public owner;
    bool public paused;
    uint256 public immutable minimumSubmitScore;
    uint256 public totalUniquePlayers;
    uint256 public totalAcceptedSubmissions;

    mapping(address => uint256) public playerBestScore;
    mapping(address => uint256) public playerLastPlayedAt;
    mapping(address => uint256) public playerSubmissionCount;

    ScoreEntry[MAX_TOP_ENTRIES] private topEntries;
    uint256 private topEntryCount;
    ScoreSubmission[] private submissions;
    mapping(address => uint256[]) private playerSubmissionIds;

    event ScoreSubmitted(address indexed player, uint256 score, uint256 previousBest, uint256 timestamp);
    event PauseStatusChanged(bool isPaused);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
        minimumSubmitScore = 0;
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
        if (playerSubmissionCount[msg.sender] == 0) {
            totalUniquePlayers += 1;
        }

        uint256 previousBest = playerBestScore[msg.sender];
        if (score > previousBest) {
            playerBestScore[msg.sender] = score;
        }

        playerLastPlayedAt[msg.sender] = block.timestamp;
        playerSubmissionCount[msg.sender] += 1;
        totalAcceptedSubmissions += 1;

        uint256 submissionId = submissions.length;
        submissions.push(
            ScoreSubmission({
                submissionId: submissionId,
                player: msg.sender,
                score: score,
                timestamp: block.timestamp
            })
        );
        playerSubmissionIds[msg.sender].push(submissionId);

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

    function getSubmissionCount() external view returns (uint256) {
        return submissions.length;
    }

    function getSubmission(uint256 index) external view returns (ScoreSubmission memory) {
        if (index >= submissions.length) revert InvalidIndex();
        return submissions[index];
    }

    function getSubmissions(uint256 start, uint256 limit) external view returns (ScoreSubmission[] memory page) {
        if (start >= submissions.length) {
            return new ScoreSubmission[](0);
        }

        uint256 endExclusive = start + limit;
        if (endExclusive > submissions.length) {
            endExclusive = submissions.length;
        }

        uint256 pageLength = endExclusive - start;
        page = new ScoreSubmission[](pageLength);
        for (uint256 i = 0; i < pageLength; i++) {
            page[i] = submissions[start + i];
        }
    }

    function getPlayerSubmissionIds(address player) external view returns (uint256[] memory) {
        return playerSubmissionIds[player];
    }

    function _updateLeaderboard(address player, uint256 score, uint256 updatedAt) internal {
        uint256 insertIndex = topEntryCount;
        for (uint256 i = 0; i < topEntryCount; i++) {
            if (score > topEntries[i].score || (score == topEntries[i].score && updatedAt > topEntries[i].updatedAt)) {
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
