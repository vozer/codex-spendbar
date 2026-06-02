# Codex Spend

Codex Spend is a small macOS menu bar app that shows your local Codex token usage,
estimated spend for today, and estimated spend across your full local Codex
history.

Usage is grouped by Codex prompt turn. Codex can emit several internal
`token_count` events while answering one prompt; the app prices those events at
their original rate and rolls them up into one visible turn.

It reads Codex session JSONL files from `~/.codex/sessions` and
`~/.codex/archived_sessions`, using `token_count` events for the actual token
numbers. It also reads `~/.codex/state_5.sqlite` through `/usr/bin/sqlite3` when
available to fill in thread titles and older model/reasoning metadata.

The dollar values are API-equivalent estimates, not an official invoice. For
ChatGPT-backed Codex usage, Codex can consume plan credits rather than billing
direct API dollars. Fast mode is estimated with the higher priority/fast rates
when the session metadata or config exposes it.

The menu can render estimates in USD or EUR. OpenAI API pricing is USD, so EUR
display uses a cached USD-to-EUR reference rate from Frankfurter and refreshes it
periodically when the app is running.

Current menu features:

- Today and all-time spend summaries.
- Warning coloring for daily spend and expensive prompt turns.
- Recent spike detection against active recent days.
- Trend charts with selectable block, line, or ASCII rendering.
- Monthly, project-folder, thread, model, and prompt-turn breakdowns.
- Preferences for currency, thresholds, chart mode, estimate labels, and start at login.
- Privacy indicator showing local files read and the optional EUR-rate network call.

Pricing references:

- OpenAI API pricing: https://platform.openai.com/docs/pricing
- Codex speed and fast-mode credit multipliers: https://developers.openai.com/codex/speed
- USD/EUR reference rates: https://frankfurter.dev/

## Requirements

- macOS 13 or newer.
- Xcode Command Line Tools with `swiftc`.
- `rg` / ripgrep is optional, but recommended for faster full-history scans.

Install Xcode Command Line Tools if needed:

```sh
xcode-select --install
```

Install ripgrep with Homebrew if wanted:

```sh
brew install ripgrep
```

## Quick Start

Clone the repository:

```sh
git clone https://github.com/imisstheoldpabl0/codex-spendbar.git
cd codex-spendbar
```

Build and run without installing:

```sh
./scripts/build.sh
open "dist/Codex Spend.app"
```

The app bundle is created at:

```text
dist/Codex Spend.app
```

After launching the app, hold Command and drag `Codex ...` in the menu bar to
the position you prefer.

## Install

Install to `~/Applications` and launch:

```sh
./scripts/install.sh
```

Install and start automatically at login:

```sh
./scripts/install.sh --login
```

Uninstall only the login item:

```sh
./scripts/install.sh --uninstall-login
```

Uninstall the app and login item:

```sh
./scripts/install.sh --uninstall
```

## Debug

Print the same summary used by the menu bar:

```sh
"dist/Codex Spend.app/Contents/MacOS/Codex Spend" --print-summary
```
