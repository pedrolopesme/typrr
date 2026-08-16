# AGENTS.md

Guidance for AI agents working on Typrr.

## Project Overview

Typrr is a standalone typing practice app — single `index.html`, zero dependencies, no build step. Open the file in any browser and it works.

## Architecture

```
index.html          ← Everything: HTML structure, CSS (<style>), JS (<script>)
design.md           ← Color palette, tokens, component states (Dracula theme)
Makefile            ← `make serve` to run local HTTP server
```

- **No frameworks.** Vanilla HTML/CSS/JS only.
- **No external resources.** No CDN fonts, no icon libraries, no analytics.
- **Single file.** CSS is in `<style>`, JS is in `<script>`. Do not split.
- **localStorage** for persistence. Key: `typrr_data`.

## Data Model

`Store.data` holds all user state:

| Field | Type | Purpose |
|-------|------|---------|
| `xp`, `level` | number | Gamification progression |
| `streak`, `lastPractice` | number, string | Daily streak tracking |
| `completedLessons` | `{lessonId: {bestWpm, bestAccuracy, stars, attempts}}` | Per-lesson progress |
| `clearedStages` | `number[]` | Stage IDs that passed the test |
| `history` | `Array<{date, themeId, lessonId, stageId, wpm, accuracy, xp, stars}>` | Session log |
| `badges` | `string[]` | Earned badge IDs |

## Theme System

Content is organized into themes, each with sequential stages:

```js
THEMES = { general: { stages: [...] }, go: { stages: [...] } }
THEME_ORDER = ["general", "go"]
```

- Each stage has `id` (int), `lessons[]`, and optional `test`.
- Lesson IDs are strings like `"1a"`, `"2c"`.
- Progress is global: `completedLessons["1a"]` works across themes.
- `clearedStages` uses integer stage IDs, scoped by current theme.

## Coding Conventions

- **CSS variables** for all colors. Reference `design.md` tokens. Never hardcode hex.
- **`var(--font-sans)`** for UI text. `var(--mono)` for code/typing. Serif is optional.
- **`CSS.escape()`** when building selectors from user/keyboard input.
- **Event listeners** on `document` or `#hiddenInput` — never inline `onkeydown`.
- **Modal keyboard handlers** must be added on open, removed on close.

## What NOT to Do

- Don't add npm, bundlers, or build tools.
- Don't split into multiple files.
- Don't add external fonts or CDN links.
- Don't use `innerHTML` with unescaped user input.
- Don't leave CSS outside the `<style>` block.
- Don't hardcode `#fff`, `white`, `#000`, or any raw color — use CSS variables.

## Testing

Open `index.html` in a browser. For automated checks:

```bash
make serve           # starts http://localhost:8080
```

Use the browser tool to navigate, type characters, verify modal behavior.

## Adding a New Theme

1. Add an entry to `THEMES` with `id`, `name`, `icon`, `desc`, `stages[]`.
2. Add the theme key to `THEME_ORDER`.
3. Each stage needs: `id`, `title`, `desc`, `icon`, `lessons[]`, optional `test`.
4. Tests require `minWpm` and `minAccuracy` fields.
5. Lesson text should be 100-250 characters for ~1-2 min typing.

## Adding Badges

Add to the `BADGES` array:

```js
{ id: "badge_id", icon: "🎯", name: "Display Name", desc: "Description", check: s => s.someField >= N }
```

The `check` function receives a stats object from `Store.get()`.

## Key Files & Line Ranges

| Section | Lines (approx) | Purpose |
|---------|----------------|---------|
| CSS `:root` | 7-30 | Design tokens |
| CSS components | 30-780 | All styling |
| `THEMES` data | 810-1180 | Content database |
| `BADGES` | 1180-1200 | Achievement definitions |
| `App` object | 1210-2100 | All game logic |
| `App.init()` | 1220 | Entry point |
| `App.renderSidebar()` | 1330 | Sidebar + theme tabs |
| `App.showResults()` | 2015 | Results modal + keyboard shortcuts |
| `App.beginTyping()` | 1600 | Typing engine setup |
