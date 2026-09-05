# Typrr

> Master touch typing with themed lessons, gamification, and daily practice.

![Typrr Dashboard](screenshots/dashboard.png)

## What is Typrr?

A standalone typing practice app — **zero dependencies, single HTML file**. Open `index.html` in any browser and start typing.

### Features

- **10 general typing stages** — from home row basics to professional speed
- **Go programming track** — muscle memory for `func`, `if err != nil`, goroutines, and real code
- **11 typing kits** — General, 10 programming languages and 9 human languages
- **Kit Hub** — browse, install and remove typing kits organised by category (General, Tech, Languages)
- **5-minute lessons** — designed for daily practice
- **Finger guide** — colour-coded keyboard and live hand diagram show which finger to use
- **Gamification** — XP, levels, streaks, star ratings, 15 achievements
- **Stage tests** — must hit WPM + accuracy targets to unlock the next stage
- **Stats that mean something** — WPM/accuracy trend charts, 5-session deltas, an 18-week practice heatmap and your most-missed keys
- **Full keyboard control** — every screen is drivable without a mouse; press `?` for the shortcut sheet
- **Focus mode** — the sidebar collapses on its own when a session starts, and comes back when you leave
- **Light, sepia and dark themes** — follows your OS by default; grab the pull cord in the header to cycle light → sepia → dark
- **Progress persistence** — everything saved in `localStorage`
- **Installable** — add it to your home screen or dock; it runs standalone and works offline

![Typrr Typing](screenshots/typing.png)

![Typrr Stats](screenshots/stats.png)

![Typrr Dark Mode](screenshots/dark.png)

## Quick Start

```bash
# Option 1: Just open it
open index.html

# Option 2: Local server
make serve          # http://localhost:8080
make serve PORT=3000
make stop
```

## Live Demo

**https://pedrolopesme.github.io/typrr/**

## Typing Kits

| Kit | Stages | Focus |
|-------|--------|-------|
| **General Typing** | 10 | Home row → speed building → mastery |
| **Go Programming** | 8 | Keywords → functions → concurrency → real code |
| **Português** | 8 | Acentos, cedilha e texto corrido em português |

Each kit has 5 lessons per stage + a gated test.

## Keyboard Shortcuts

Press <kbd>?</kbd> anywhere for the full list.

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Move between cards, Vim-style (left/down/up/right) |
| `g``g` / `G` | First / last card |
| `o` | Open the focused card |
| `1`–`9` | Jump to a numbered card |
| `n` | Start the next recommended lesson |
| `g``d` `g``s` `g``b` `g``h` | Go to Dashboard / Stats / Badges / History |
| `g``k` | Go to the Kit Hub |
| `g``t` / `g``T` | Next / previous typing kit |
| `m` | Pull the cord (light → sepia → dark) |
| `c` | Collapse / expand the sidebar |
| `Space` | Start the typing session |
| `Esc` | Go back / dismiss |
| `1` `2` `3` `4` | Post-session actions |

## Design

White-first and low-chrome: hairline-bordered cards on white, with saturated colour reserved for meaning — indigo for progress and focus, green for correct, red for errors, amber for streaks and tests.

Titles are set in a slab serif (`American Typewriter` → `Rockwell` → Georgia) for the typewriter voice, labels in letterspaced mono small caps, body in the system sans. All faces are already on your machine — no webfonts.

Themes are pure token swaps on `html[data-theme]` (`:root` light, `sepia`, `dark`), resolved before first paint so they never flash. The switch itself is a ceiling pull cord at the far right of the header — a real Verlet rope that hangs, swings and trips mid-pull like a lamp chain — and it cycles light → sepia → dark. See [design.md](design.md) for the full token reference.

## Project Structure

```
index.html            ← The entire app (HTML + CSS + JS)
manifest.webmanifest  ← Web app manifest
sw.js                 ← Service worker: offline shell
icons/                ← App icons (192, 512, maskable, apple-touch)
design.md             ← Design system: tokens, states, data-viz rules
AGENTS.md             ← Conventions for AI agents
Makefile              ← Local server shortcuts
```

The app itself is still one file. `index.html` opens and runs on its own — the
favicon and logo are inlined, so nothing is missing. The manifest, worker and
icon files are deployment assets that only engage over `http(s)`.

## Install It

Served over https, Typrr is a full web app:

- **Chrome / Edge** — install button in the address bar
- **iOS Safari** — Share → Add to Home Screen
- **Android Chrome** — menu → Install app

It launches standalone, matches your light or dark theme in the OS chrome, and
the service worker keeps it working with no network.

## Contributing

See [AGENTS.md](AGENTS.md) for architecture, data model, and coding conventions.

## License

MIT
