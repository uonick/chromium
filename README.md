# Chromium Downloads

A tiny static page that always points to the latest Chromium snapshot builds. No hunting through Google's snapshot index every time you need a fresh download link — just open the site and click download.

## Why this exists

Official Chromium builds live in a large snapshot directory on Google Cloud Storage. Finding the current build means opening the index, picking your platform, scrolling to the latest revision, and copying a long URL. This project does that once a day and gives you a single bookmark with a direct download button.

## What you get

- **macOS (Intel)** — `chrome-mac.zip`
- **macOS (Apple Silicon)** — `chrome-mac.zip`
- **Windows (x64)** — `chrome-win.zip`
- **Linux (x64)** — `chrome-linux.zip`

Each tab shows the current revision number and when the page was last refreshed. These are snapshot builds: they do not auto-update after you install them.

## How it works

1. `scripts/update.sh` fetches the latest revision from [Chromium snapshots](https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html) for each platform.
2. It fills placeholders in `index.template.html` and writes `site/index.html`.
3. A GitHub Actions workflow runs daily (and on demand) to regenerate the page and deploy it to GitHub Pages.

## Run locally

```bash
bash scripts/update.sh
open site/index.html
```

## Deploy

The workflow in `.github/workflows/update.yml` builds `site/` and publishes it via GitHub Pages. Enable Pages in the repo settings (source: GitHub Actions) if you have not already.

## Disclaimer

This is an unofficial convenience page. Builds come straight from Google's Chromium snapshot storage — not from Google Chrome or any third-party distributor. Use at your own risk.
