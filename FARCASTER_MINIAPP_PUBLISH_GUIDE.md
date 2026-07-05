# Farcaster Mini App Publish Guide

This guide is written for the final production launch of `Base 2048 Pulse` as a Farcaster Mini App.

## What Is Already Done In Code

The project already includes the core Mini App requirements:

- `fc:miniapp` and `fc:frame` metadata in `index.html`
- runtime readiness with `sdk.actions.ready()`
- production manifest at `/.well-known/farcaster.json`
- production URL set to `https://base2048pulse.vercel.app/`

That means the remaining work is mostly launch verification plus one manual ownership-signing step.

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

## The One Manual Step You Must Do

Farcaster publishing requires a real `accountAssociation` object.

This is a JSON Farcaster Signature proving that:

- you control the Farcaster account
- you are associating it with the exact app domain

I cannot generate this value safely by guessing. You must obtain it through the Farcaster / Warpcast Mini App manifest tool flow.

## Exact Manual Flow

### Step 1: Open Warpcast Developer Tools

Sign in to your Farcaster / Warpcast account in the browser.

Then open Warpcast Developer Tools and use these exact tools:

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
- generates or returns the signed account association object

### Step 2: Use Your Production Domain

Enter this exact domain:

```text
base2048pulse.vercel.app
```

Do not enter:

- `https://base2048pulse.vercel.app`
- `base2048pulse.vercel.app/`
- any subpath

### Step 3: Generate the Account Association

Use the Manifest Tool publishing flow to generate the signed account association.

When the process succeeds, you should receive three values:

- `header`
- `payload`
- `signature`

These are the exact three values that must replace the placeholders in:

```text
/.well-known/farcaster.json
```

### Step 4: Send Me The Three Values

Paste the three values back to me exactly as returned:

```json
{
  "header": "PASTE_HERE",
  "payload": "PASTE_HERE",
  "signature": "PASTE_HERE"
}
```

Once you send them, I will place them into the manifest for you exactly.

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

Note:

- I updated the app to call `sdk.actions.ready({ disableNativeGestures: true })`
- this is important because the game uses swipe gestures and could otherwise conflict with native Mini App dismissal gestures

## Optional Neynar Path

The Neynar docs are useful for:

- understanding Mini App metadata
- understanding the convert-web-app flow
- understanding notifications and webhook setup later

But for this project, you do not need to rebuild the app using the Neynar starter kit.

The current project is already in the "convert an existing web app to a Mini App" stage.

## Recommended Verification After Pasting Real Values

After I place the real `accountAssociation` values into the manifest, check:

1. The manifest is still reachable on the production domain.
2. The Mini App domain tool reports the domain as valid.
3. The app opens from the Mini App launch surface correctly.
4. Share behavior still works.
5. The production URL in all metadata still points to the same domain.

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
