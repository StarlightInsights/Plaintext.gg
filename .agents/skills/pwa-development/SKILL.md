---
name: pwa-development
description: "Implement Progressive Web App features for React and Svelte projects. This skill should be used when the user asks to 'make a PWA', 'add offline support', 'create a service worker', 'fix caching issues', or wants installable web apps. Keywords: PWA, service worker, offline, manifest, caching, installable, Workbox, vite-pwa."
license: MIT
compatibility: Works with React, Svelte/SvelteKit, Vite, Next.js.
metadata:
  author: jwynia
  version: "1.0"
  type: utility
  mode: assistive
  domain: development
---

# PWA Development

Implement Progressive Web App features including service workers, caching strategies, offline support, and installation prompts for React and Svelte applications.

## When to Use This Skill

Use this skill when:
- Adding PWA capabilities to a web app
- Implementing offline support
- Creating service worker caching strategies
- Debugging PWA installation issues
- Handling iOS-specific PWA quirks

Do NOT use this skill when:
- Building backend APIs
- Working on requirements/design (use those skills first)
- Need complex offline-first architecture (design first)

## Core Principle

**PWAs fail when offline behavior is an afterthought.** A PWA is not "add service worker to existing app." It's a fundamental architectural decision about data flow, caching, and connectivity failure.

## Diagnostic States

### P0: No PWA Setup

**Symptoms:** No manifest.json, no service worker, online-only

**Interventions:**
- Inspect `static/manifest.webmanifest` for install metadata completeness
- Verify the app shell and service worker registration in `src/routes/+layout.svelte`
- Verify PWA plugin configuration in `vite.config.ts`

### P1: Basic Manifest Only

**Symptoms:** Manifest exists but SW missing, breaks offline

**Key Questions:**
- What content MUST be available offline?
- What should always be fresh (network-first)?

**Interventions:**
- Audit `vite.config.ts` runtime caching rules
- Verify the offline fallback page at `static/offline.html`
- Confirm `src/routes/+layout.svelte` registers the service worker only in production

### P2: Caching Issues

**Symptoms:** Stale content, unexpected caching behavior

**Interventions:**
- Audit `vite.config.ts` for precache scope, runtime caching, and expiration rules
- Review which files are emitted to `static/` and whether they belong in the cache
- Add or adjust cache expiration and cleanup directly in the Workbox config

### P3: Update Problems

**Symptoms:** Users stuck on old versions, multiple refreshes needed

**Interventions:**
- Verify `skipWaiting` and `clientsClaim` usage in `vite.config.ts`
- Review the registration flow in `src/routes/+layout.svelte`
- Add update notification UI in the app codebase if the current UX is too silent

### P4: Offline Data Gaps

**Symptoms:** User actions lost offline, no sync indicator

**Interventions:**
- Implement IndexedDB for offline storage
- Add Background Sync API
- Create sync status UI

### P5: iOS Issues

**Symptoms:** Works on Android, breaks on iOS

**Interventions:**
- Review the existing head metadata in `src/app.html` and route components
- Add `apple-mobile-web-app-*` metadata if installation behavior needs improvement
- Handle storage eviction and offline recovery gracefully in client persistence code

### P6: Production Ready

**Indicators:** Lighthouse PWA 100, works offline, updates cleanly

## Caching Strategies

| Strategy | Use For | Behavior |
|----------|---------|----------|
| Cache First | Static assets, fonts | Serve from cache, update in background |
| Network First | API data, user content | Try network, fall back to cache |
| Stale While Revalidate | Semi-static content | Serve stale, update cache for next time |
| Network Only | Auth, real-time data | Always network, no caching |

## Repo Files To Inspect

| File | Purpose |
|------|---------|
| `vite.config.ts` | PWA plugin setup, precache scope, runtime caching |
| `src/routes/+layout.svelte` | Service worker registration flow |
| `static/manifest.webmanifest` | Install metadata |
| `static/offline.html` | Offline navigation fallback |
| `src/app.html` | Global head metadata |

## Anti-Patterns

### The Everything Cache
Precaching every asset - massive initial download.
**Fix:** Precache only critical app shell. Runtime cache content.

### The Immortal Cache
Never expiring caches - stale content forever.
**Fix:** Cache versioning, delete old on activate, set max age.

### The Silent Update
Forcing updates without notification.
**Fix:** Notify user, let them choose when to refresh.

### The iOS Afterthought
Building for Chrome, testing iOS last.
**Fix:** Test iOS early. Accept iOS limitations.

## Framework Quick Reference

### React + Vite
```bash
npm i -D vite-plugin-pwa
```

### SvelteKit
```bash
npm i -D @vite-pwa/sveltekit
```

### Next.js
```bash
npm i next-pwa
```

Use the framework's official docs for deeper configuration details when the local repo files are insufficient.

## Debugging Checklist

1. **DevTools > Application > Manifest** - Valid?
2. **DevTools > Application > Service Workers** - Registered?
3. **DevTools > Application > Cache Storage** - What's cached?
4. **DevTools > Network > Offline** - Works offline?
5. **Lighthouse > PWA** - Score and failures?
6. **iOS Safari** - Test on actual device

## Related Skills

- **requirements-analysis** - Determine offline requirements
- **system-design** - PWA architecture decisions
- **react-pwa** - React-specific PWA implementation
