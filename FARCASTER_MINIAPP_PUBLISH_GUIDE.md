# Farcaster Mini App Publish Guide

This guide is written for the final production launch of `Base 2048 Pulse` as a Farcaster Mini App.

## What Is Already Done In Code

The project already includes the core Mini App requirements:

- `fc:miniapp` and `fc:frame` metadata in `index.html`
- runtime readiness with `sdk.actions.ready()`
- production manifest at `/.well-known/farcaster.json`
- production URL set to `https://base2048pulse.vercel.app/`
- signed `accountAssociation` values already placed in the production manifest
- final stable PNG assets for Farcaster / Open Graph previews

That means the remaining work is now final verification, debugging, and publish confirmation.

## What You Must Have Ready First

Before opening any Farcaster or Warpcast developer tools, make sure:

1. The production app is deployed on Vercel.
2. The Mini App domain is exactly `base2048pulse.vercel.app`.
3. The manifest is reachable at:

```text
https://base2048pulse.vercel.app/.well-known/farcaster.json
```

4. The app homepage is reachable at:

```text
https://base2048pulse.vercel.app/
```

Important:

- Use the domain only: `base2048pulse.vercel.app`
- Do not use `https://`
- Do not use a path such as `/index.html`
- Do not switch between `www` and non-`www`

The domain in the account association payload must match the hosted manifest domain exactly.

## Current Status

The Farcaster ownership-signing step is already complete.

The production manifest already contains:

- a real signed `accountAssociation`
- the correct production domain
- stable local preview assets served from your own app domain

You do not need to regenerate the signature unless one of these changes:

- the Farcaster account
- the production domain
- the app ownership association

## Final Launch Flow

### Step 1: Open Warpcast Developer Tools

Sign in to your Farcaster / Warpcast account in the browser.

Then open these tools:

- Manifest tool:

```text
https://farcaster.xyz/~/developers/mini-apps/manifest
```

- Preview / Debug tool:

```text
https://farcaster.xyz/~/developers/mini-apps/debug
```

You are looking for the tool that:

- checks Mini App domain status
- reads the hosted manifest
- previews how the Mini App opens inside Farcaster

### Step 2: Use Your Production Domain

Enter this exact domain:

```text
base2048pulse.vercel.app
```

Do not enter:

- `https://base2048pulse.vercel.app`
- `base2048pulse.vercel.app/`
- any subpath

### Step 3: Validate What The Manifest Tool Sees

Use the Manifest Tool to confirm:

- the domain is recognized correctly
- the manifest loads successfully
- the account association is accepted
- the Mini App metadata points to the production app

The manifest should resolve from:

```text
https://base2048pulse.vercel.app/.well-known/farcaster.json
```

## How To Test Before Final Publish

Use the Mini App Debug Tool here:

```text
https://farcaster.xyz/~/developers/mini-apps/debug
```

In the debug tool:

1. Sign in to Warpcast on desktop.
2. Paste the app URL:

```text
https://base2048pulse.vercel.app/
```

3. Hit `Preview`.
4. Confirm the app opens without an infinite splash/loading state.
5. Confirm swipe gameplay feels correct inside the Mini App shell.
6. Confirm the launch screen uses the app icon correctly.
7. Confirm the embed preview image loads instead of a temporary image-generation placeholder.
8. Confirm the app remains responsive after connecting a wallet.

Note:

- I updated the app to call `sdk.actions.ready({ disableNativeGestures: true })`
- this is important because the game uses swipe gestures and could otherwise conflict with native Mini App dismissal gestures

## Final Asset Checklist

These final production assets should load directly on the live domain:

```text
https://base2048pulse.vercel.app/assets/farcaster-cover.png
https://base2048pulse.vercel.app/assets/farcaster-icon.png
```

Important:

- the app now uses fixed PNG assets for reliability
- the old editable SVG files are optional source files only
- runtime metadata should point to the PNG files, not the SVG files

## Optional Neynar Path

The Neynar docs are useful for:

- understanding Mini App metadata
- understanding the convert-web-app flow
- understanding notifications and webhook setup later

But for this project, you do not need to rebuild the app using the Neynar starter kit.

The current project is already in the "convert an existing web app to a Mini App" stage.

## Recommended Final Verification

Now that the real `accountAssociation` values are already in place, check:

1. The manifest is still reachable on the production domain.
2. The Mini App domain tool reports the domain as valid.
3. The app opens from the Mini App launch surface correctly.
4. Share behavior still works.
5. The production URL in all metadata still points to the same domain.
6. The Farcaster preview image loads from `assets/farcaster-cover.png`.
7. The Farcaster icon / splash asset loads from `assets/farcaster-icon.png`.
8. The manifest still matches the exact production domain with no path mismatch.

## Optional Next Layer After Publishing

These are not required for the first publish, but are good follow-up upgrades:

- add notification support with a `webhookUrl`
- add a dedicated Mini App "Add App" flow
- add Mini App auth
- add analytics through Neynar or another supported host

## Current Manifest Status

The production manifest now contains a real signed `accountAssociation` for:

```text
base2048pulse.vercel.app
```

If you later change the domain or connect a different Farcaster account, you must repeat the manifest signing flow and replace the three values again.

## Final Go-Live Decision

You are ready to publish publicly once all of these are true:

- the app opens in the Warpcast Debug Tool
- the manifest is valid
- the Farcaster preview image loads
- the icon / splash image loads
- gameplay works inside the Mini App shell
- wallet connect and score submission still behave correctly
