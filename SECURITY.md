# Security Notes 🛡️

This document explains the intended trust and risk boundaries of this project. 🔍

## What This App Does ✅

- Runs a local 2048 game in the browser
- Connects to a wallet only when the user chooses to do so
- Reads leaderboard data from a fixed Base Mainnet contract
- Submits a final score to that contract when the user confirms a transaction
- Serves a signed Farcaster Mini App manifest from `/.well-known/farcaster.json`
- Uses fixed local PNG assets for Farcaster / Open Graph preview images

## What This App Does Not Do ⛔

- It does not request ERC-20 token approvals
- It does not request NFT approvals
- It does not use `permit`
- It does not initiate arbitrary transfers
- It does not custody funds
- It does not use a backend to store wallet or gameplay data

## Wallet Safety Clarifications 👛

Users should understand the difference between these common wallet actions:

### Safe for this app ✅

- Connecting a wallet with `eth_requestAccounts`
- Switching to Base Mainnet
- Signing a transaction that calls `submitScore(uint256)`

### Not expected in this app 🚫

- Approving token access
- Signing typed data unrelated to score submission
- Sending ETH or tokens to an externally owned address
- Blind-signing unrelated messages

If a wallet prompt asks for anything beyond a standard score submission transaction, stop and inspect the request carefully.

## Contract Safety Assumptions 📜

This frontend assumes the deployed contract:

- stores scores only
- has no payable public score path
- does not move user funds
- exposes the expected read functions
- has verified source code on BaseScan

If the deployed contract is replaced, modified, or unverified, users should not trust the frontend blindly.

## Frontend Trust Boundary 🌐

This repository is mostly static frontend code plus one small serverless lookup route. It can be audited directly in GitHub.

Recommended user checks:

1. Open the repository and inspect `index.html`
2. Confirm the contract address matches the intended deployed contract
3. Confirm the BaseScan page for that contract is verified
4. Confirm the contract ABI and the frontend ABI are aligned
5. Confirm `/.well-known/farcaster.json` points to your exact production domain
6. Confirm the image assets referenced by the manifest are local project files, not unknown third-party URLs

## Operational Security for the Repository Owner 🔐

- Never commit private keys, seed phrases, or wallet export files
- Never store deployer secrets inside the repository
- Never paste private RPC credentials into public files
- Never use a browser wallet with large treasury balances for casual testing
- Prefer a dedicated deployer wallet for contract deployment and admin functions

## Vercel and GitHub Safety ☁️

- Review every commit before pushing to GitHub
- Treat GitHub as public unless the repository is intentionally private
- If the repository is public, assume anyone can inspect the code immediately
- `ETHERSCAN_API_KEY` is optional, not mandatory
- If `ETHERSCAN_API_KEY` is not set, the app falls back to best-effort explorer page parsing for nametags
- Do not place private API secrets in frontend files such as `index.html`

## User-Facing Warnings You Should Keep Clear ⚠️

Before publishing, make sure your live page makes these points clear:

- Connecting a wallet does not mean approving assets
- On-chain score submission costs gas
- Users should verify they are on Base Mainnet
- Users should inspect the contract on BaseScan if they want full confidence
- Farcaster previews may cache old images for a while after deployment

## Recommended Final Checks 🧪

- Run one real wallet connection test
- Run one real score submission test
- Confirm the transaction targets the intended contract address
- Confirm BaseScan shows the expected contract interaction
- Confirm no unexpected wallet permissions are requested
- Confirm `/.well-known/farcaster.json` loads on the live domain
- Confirm `assets/farcaster-cover.png` and `assets/farcaster-icon.png` load correctly on the live domain
