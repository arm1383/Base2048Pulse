# Base 2048 Pulse 🎮🔵

A polished 2048 game with smooth desktop and mobile controls, wallet connection, flexible on-chain score submission, multi-range leaderboards, and social sharing on Base Mainnet. ⚡

## Live Contract 📜

- Network: `Base Mainnet`
- Chain ID: `8453`
- Locked Contract Address: `0xaf73175B8E033B26b334B07823eabb2cbF15E2c7`

## What Is New ✨

- `All-Time`, `Weekly`, and `Daily` leaderboard views
- Score sharing on `X` and `Farcaster`
- Social links for the project and creator profiles
- Farcaster Mini App readiness via meta tags, manifest, and runtime SDK support
- Safari iPhone wallet support through a wallet-app browser flow, with official mobile deep links for MetaMask, Coinbase Wallet, and Trust Wallet when Safari has no injected provider
- Final Farcaster-ready PNG social assets for reliable embed previews
- A signed `accountAssociation` in `/.well-known/farcaster.json`
- Flexible score submission flow for the V2 contract
- Support for storing all submissions and calculating broader leaderboard ranking
- Explorer-backed `base.eth` name display in the leaderboard through a small Vercel API route

## Repository Purpose 🚀

This repository is designed for a simple GitHub-to-Vercel workflow:

1. Push the repository to your GitHub account
2. Import the repository into Vercel
3. Deploy the frontend plus a tiny Vercel serverless route for leaderboard name tags

No database and no build command are required.

This repository is now configured with a live Reown / WalletConnect project ID for non-Safari fallback flows. On iPhone Safari, the frontend now prefers opening the dapp inside a wallet app browser for the most reliable mobile connection flow. If you rotate the Reown project or deploy a fork, update `REOWN_PROJECT_ID` in `index.html` before pushing the live build.

## Files You Need 📦

- `index.html` — the full frontend game, UI, wallet flow, leaderboard logic, and Farcaster meta tags
- `api/address-tag.js` — a lightweight Vercel API route for BaseScan / Etherscan-backed `base.eth` name lookup
- `.well-known/farcaster.json` — the signed Farcaster Mini App manifest
- `assets/farcaster-cover.png` — the final stable social preview image
- `assets/farcaster-icon.png` — the final stable Mini App icon / splash image
- `Base2048Pulse.sol` — the Remix-compatible Solidity contract source
- `vercel.json` — minimal Vercel configuration

## Minimal Deployable Set ✅

If you only want the smallest final deployable version of the project, keep these files:

- `index.html`
- `Base2048Pulse.sol`
- `vercel.json`
- `.well-known/farcaster.json`
- `api/address-tag.js`
- `assets/farcaster-cover.png`
- `assets/farcaster-icon.png`

## Optional Repository Docs 📘

These files are recommended for a complete public repository, but they are not required for the app to run:

- `README.md`
- `SECURITY.md`
- `GITHUB_VERCEL_DEPLOYMENT_GUIDE.md`
- `FARCASTER_MINIAPP_PUBLISH_GUIDE.md`

## Recommended Repository Structure 🗂️

```text
.
├── Base2048Pulse.sol
├── README.md
├── SECURITY.md
├── GITHUB_VERCEL_DEPLOYMENT_GUIDE.md
├── FARCASTER_MINIAPP_PUBLISH_GUIDE.md
├── .well-known/
│   └── farcaster.json
├── api/
│   └── address-tag.js
├── assets/
│   ├── farcaster-cover.png
│   └── farcaster-icon.png
├── index.html
└── vercel.json
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

You can test the UI locally with any static file server, but the explorer-backed leaderboard name tag route is intended for Vercel deployment.

Safari on iPhone now opens a wallet-selection modal that deep-links into MetaMask, Coinbase Wallet, or Trust Wallet so the game can continue inside that wallet browser. Reown / WalletConnect remains available for non-Safari fallback paths.

Example:

```bash
python3 -m http.server 4173
```

Then open:

```text
http://127.0.0.1:4173/
```

For final Farcaster assets, also verify these paths after deployment:

```text
https://base2048pulse.vercel.app/assets/farcaster-cover.png
https://base2048pulse.vercel.app/assets/farcaster-icon.png
https://base2048pulse.vercel.app/.well-known/farcaster.json
```

## GitHub to Vercel Flow 🌐

Follow the exact steps in:

- `GITHUB_VERCEL_DEPLOYMENT_GUIDE.md`
- `FARCASTER_MINIAPP_PUBLISH_GUIDE.md`

## Before Publishing ✅

- Verify the contract on BaseScan
- Optionally add `ETHERSCAN_API_KEY` in Vercel Project Settings for the most reliable explorer metadata lookup
- Test one real wallet connection on Base Mainnet
- Test one real score submission
- Confirm the leaderboard refreshes correctly
- Confirm `Daily`, `Weekly`, and `All-Time` views load correctly
- Confirm X and Farcaster share actions open the correct compose flows
- Confirm the Farcaster preview image and icon load from the deployed `assets/` directory
- Confirm the signed Mini App manifest is reachable at `/.well-known/farcaster.json`
- Confirm the deployed contract address is correct in `index.html`
- Confirm `Connect Wallet` opens the wallet-selection modal in iPhone Safari and that at least one wallet app deep link opens the game inside the wallet browser
- If you plan to launch in Farcaster, follow `FARCASTER_MINIAPP_PUBLISH_GUIDE.md`

## Notes ℹ️

- This build is locked to a single deployed contract
- The contract address is intentionally not editable in the UI
- The current production contract is the V2 submission-friendly contract
- Safari fallback support is active in this repository through wallet-app deep links, while `REOWN_PROJECT_ID` remains available for non-Safari WalletConnect fallback paths
- If you redeploy a new contract later, update the hardcoded address in `index.html` before pushing a new version
