# Base 2048 Pulse 🎮🔵

A polished single-file 2048 game with smooth desktop and mobile controls, wallet connection, flexible on-chain score submission, multi-range leaderboards, and social sharing on Base Mainnet. ⚡

## Live Contract 📜

- Network: `Base Mainnet`
- Chain ID: `8453`
- Locked Contract Address: `0xaf73175B8E033B26b334B07823eabb2cbF15E2c7`

## What Is New ✨

- `All-Time`, `Weekly`, and `Daily` leaderboard views
- Score sharing on `X` and `Farcaster`
- Social links for the project and creator profiles
- Farcaster Mini App readiness via meta tags, manifest, and runtime SDK support
- Flexible score submission flow for the V2 contract
- Support for storing all submissions and calculating broader leaderboard ranking

## Repository Purpose 🚀

This repository is designed for a simple GitHub-to-Vercel workflow:

1. Push the repository to your GitHub account
2. Import the repository into Vercel
3. Deploy as a static site

No backend, no database, and no build command are required.

## Files You Need 📦

- `index.html` — the full frontend game, UI, wallet flow, and leaderboard logic
- `Base2048Pulse.sol` — the Remix-compatible Solidity contract source
- `vercel.json` — minimal Vercel configuration
- `README.md` — project overview and usage notes
- `SECURITY.md` — crypto and wallet security clarifications
- `GITHUB_VERCEL_DEPLOYMENT_GUIDE.md` — exact GitHub and Vercel publishing steps
- `.gitignore` — excludes unnecessary local artifacts

## Recommended Repository Structure 🗂️

```text
.
├── Base2048Pulse.sol
├── GITHUB_VERCEL_DEPLOYMENT_GUIDE.md
├── README.md
├── SECURITY.md
├── index.html
├── vercel.json
└── .gitignore
```

## Smart Contract Interface 🧠

The frontend expects this contract interface:

```solidity
function paused() view returns (bool)
function minimumSubmitScore() view returns (uint256)
function getEntryCount() view returns (uint256)
function getTopEntries() view returns ((address player,uint256 score,uint256 updatedAt)[])
function getPlayerBestScore(address player) view returns (uint256)
function getSubmissionCount() view returns (uint256)
function getSubmission(uint256 index) view returns ((uint256 submissionId,address player,uint256 score,uint256 timestamp))
function getSubmissions(uint256 start,uint256 limit) view returns ((uint256 submissionId,address player,uint256 score,uint256 timestamp)[])
function getPlayerSubmissionIds(address player) view returns (uint256[])
function submitScore(uint256 score)
```

## Security Model 🛡️

This project is intentionally narrow in scope:

- The contract stores scores only
- The frontend does not request token approvals
- The frontend does not request permit signatures
- The frontend does not ask users to transfer assets
- The game remains playable without a wallet
- A wallet is only needed for on-chain score submission
- The V2 contract accepts score submissions at any point in a run

Read `SECURITY.md` before publishing.

## Local Test 🧪

You can test locally with any static file server.

Example:

```bash
python3 -m http.server 4173
```

Then open:

```text
http://127.0.0.1:4173/
```

## GitHub to Vercel Flow 🌐

Follow the exact steps in:

- `GITHUB_VERCEL_DEPLOYMENT_GUIDE.md`

## Before Publishing ✅

- Verify the contract on BaseScan
- Test one real wallet connection on Base Mainnet
- Test one real score submission
- Confirm the leaderboard refreshes correctly
- Confirm `Daily`, `Weekly`, and `All-Time` views load correctly
- Confirm X and Farcaster share actions open the correct compose flows
- Confirm the deployed contract address is correct in `index.html`

## Notes ℹ️

- This build is locked to a single deployed contract
- The contract address is intentionally not editable in the UI
- The current production contract is the V2 submission-friendly contract
- If you redeploy a new contract later, update the hardcoded address in `index.html` before pushing a new version
