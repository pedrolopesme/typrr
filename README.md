# Typrr

> Master touch typing with themed lessons, gamification, and daily practice.

![Typrr Dashboard](screenshots/dashboard.png)

## What is Typrr?

A standalone typing practice app — **zero dependencies, single HTML file**. Open `index.html` in any browser and start typing.

### Features

- **10 general typing stages** — from home row basics to professional speed
- **Go programming track** — muscle memory for `func`, `if err != nil`, goroutines, and real code
- **5-minute lessons** — designed for daily practice
- **Finger guide** — color-coded keyboard shows which finger to use for each key
- **Gamification** — XP, levels, streaks, star ratings, 15 achievements
- **Stage tests** — must hit WPM + accuracy targets to unlock the next stage
- **Progress persistence** — everything saved in `localStorage`
- **Keyboard shortcuts** — `Enter`/`Space` to start, `1`/`2`/`3` for post-lesson navigation

![Typrr Typing](screenshots/typing.png)

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

## Themes

| Theme | Stages | Focus |
|-------|--------|-------|
| **General Typing** | 10 | Home row → speed building → mastery |
| **Go Programming** | 8 | Keywords → functions → concurrency → real code |

Each theme has 5 lessons per stage + a gated test.

## Design

Built on the [Dracula](https://draculatheme.com) color palette — dark, vibrant, high-contrast. See [design.md](design.md) for the full token reference.

## Project Structure

```
index.html      ← The entire app (HTML + CSS + JS)
design.md       ← Color palette and component states
AGENTS.md       ← Conventions for AI agents
Makefile        ← Local server shortcuts
```

## Contributing

See [AGENTS.md](AGENTS.md) for architecture, data model, and coding conventions.

## License

MIT
