# GitHub to Vercel Deployment Guide

This guide shows the exact workflow for publishing this project through a new GitHub repository and then importing that repository into Vercel.

## 1. Prepare the Local Folder

Make sure the folder contains these files:

- `index.html`
- `api/address-tag.js`
- `.well-known/farcaster.json`
- `assets/farcaster-cover.png`
- `assets/farcaster-icon.png`
- `Base2048Pulse.sol`
- `README.md`
- `SECURITY.md`
- `GITHUB_VERCEL_DEPLOYMENT_GUIDE.md`
- `vercel.json`
- `.gitignore`

Files that are not required for publishing should not be included.

If you want the smallest final deployable set, these files alone are enough:

- `index.html`
- `api/address-tag.js`
- `.well-known/farcaster.json`
- `assets/farcaster-cover.png`
- `assets/farcaster-icon.png`
- `Base2048Pulse.sol`
- `vercel.json`

## 2. Create a New GitHub Repository

1. Sign in to GitHub
2. Click the `+` button in the top-right corner
3. Choose `New repository`
4. Enter a repository name
5. Use this exact repository name: `Base2048Pulse`
6. Choose `Public` or `Private`
7. Do not initialize it with a README, `.gitignore`, or license if you are uploading this prepared folder
8. Click `Create repository`

## 3. Upload the Project to GitHub

You have two common options.

### Option A: Upload Through the GitHub Website

1. Open the new empty repository page
2. Click `uploading an existing file`
3. Drag and drop the prepared files into the page
4. Add a commit message such as:

```text
Initial publish of Base 2048 Pulse
```

5. Click `Commit changes`

### Option B: Push with Git

If Git is already installed locally:

```bash
git init
git branch -M main
git add .
git commit -m "Initial publish of Base 2048 Pulse"
git remote add origin https://github.com/YOUR_USERNAME/Base2048Pulse.git
git push -u origin main
```

Replace:

- `YOUR_USERNAME`
- `Base2048Pulse`

## 4. Review the Repository Before Deploying

Open the repository in GitHub and confirm:

- `index.html` is present at the repository root
- `api/address-tag.js` is present for explorer-backed leaderboard name tags
- `.well-known/farcaster.json` is present and contains the signed account association
- `assets/farcaster-cover.png` and `assets/farcaster-icon.png` are present
- `vercel.json` is present at the repository root
- `Base2048Pulse.sol` is present
- the contract address in `index.html` is correct
- no private data exists anywhere in the repository
- the current production contract address is `0xaf73175B8E033B26b334B07823eabb2cbF15E2c7`

## 5. Import the Repository into Vercel

1. Sign in to Vercel
2. Click `Add New...`
3. Choose `Project`
4. Import the GitHub repository you just created
5. If GitHub is not connected to Vercel yet, authorize GitHub access first
6. Select the correct repository

## 6. Configure the Vercel Project

This project uses a plain frontend plus a small Vercel serverless route and does not need a framework preset.

Recommended settings:

- Framework Preset: `Other`
- Build Command: leave empty
- Output Directory: leave empty
- Install Command: leave empty

If you want wallet connection to work in iPhone Safari, replace `REPLACE_WITH_REOWN_PROJECT_ID` inside `index.html` with a real Reown / WalletConnect project ID before deploying.

Optional environment variable:

- `ETHERSCAN_API_KEY` = your Etherscan API key for the most reliable `base.eth` / explorer nametag lookup on Base

If you do not set the API key, the app falls back to a best-effort explorer page lookup, but the API-backed path is still the most reliable option.

Then click `Deploy`

## 7. Test the Live Site

After deployment:

1. Open the Vercel URL
2. Confirm the page loads correctly
3. Confirm the contract section shows the locked Base Mainnet address
4. Confirm the BaseScan link works
5. Confirm `https://base2048pulse.vercel.app/.well-known/farcaster.json` loads
6. Confirm `https://base2048pulse.vercel.app/assets/farcaster-cover.png` loads
7. Confirm `https://base2048pulse.vercel.app/assets/farcaster-icon.png` loads
8. Confirm the leaderboard loads
9. Confirm `All-Time`, `Weekly`, and `Daily` tabs load correctly
10. Confirm leaderboard rows with registered Base names show `*.base.eth` instead of raw wallet addresses
11. Confirm the X and Farcaster share buttons open the correct share flows
12. Connect a wallet
13. Switch to Base Mainnet if prompted
14. Start a run and submit a score at any point if you are testing the V2 contract flow
15. Refresh the leaderboard
16. If desired, continue until `Game Over` and test the end-state UI as well
17. Confirm `Connect Wallet` opens the WalletConnect / Reown path in iPhone Safari once the Reown project ID is configured

If you also want to publish the app as a Farcaster Mini App, continue with:

- `FARCASTER_MINIAPP_PUBLISH_GUIDE.md`

Useful Farcaster tools:

- Manifest tool: `https://farcaster.xyz/~/developers/mini-apps/manifest`
- Debug tool: `https://farcaster.xyz/~/developers/mini-apps/debug`

## 8. Crypto Security Review Before Sharing

Before sharing the live URL publicly, confirm these points:

- The contract on BaseScan is the correct one
- The contract is verified
- The wallet prompt only requests connection and score submission
- The site never asks for token approvals
- The site never asks for unrelated message signatures
- The site never asks users to transfer assets
- The live site points to the intended V2 production contract address
- The live Farcaster manifest points to the correct production domain
- The preview image and icon are served from your own deployed `assets/` folder
- If Safari support matters, the live frontend no longer contains the placeholder `REPLACE_WITH_REOWN_PROJECT_ID`

## 9. How to Update the Site Later

If you want to update the live app:

1. Edit the files locally
2. Commit and push to GitHub
3. Vercel automatically redeploys the new commit

Example:

```bash
git add .
git commit -m "Update UI and gameplay polish"
git push
```

## 10. If You Ever Redeploy a New Contract

Because this build is locked to a single contract, you must update the hardcoded address in `index.html`.

Search for:

```text
DEFAULT_CONTRACT_ADDRESS
```

Then replace the old contract address with the new one, commit, push, and let Vercel redeploy.

If you also want Safari on iPhone to connect wallets directly from the public site, update the `REOWN_PROJECT_ID` placeholder in that same file before pushing the next deployment.

Current production address:

```text
0xaf73175B8E033B26b334B07823eabb2cbF15E2c7
```

## 11. Final Pre-Share Checklist

- GitHub repository is clean
- No secret files are committed
- Vercel deployment succeeds
- Live site loads without errors
- Wallet connect works
- iPhone Safari WalletConnect fallback works after configuring a real Reown project ID
- Base network switch works
- On-chain score submission works
- Leaderboard refresh works
- Daily / Weekly / All-Time tabs work
- Share buttons work
- Farcaster manifest loads
- Farcaster preview assets load
