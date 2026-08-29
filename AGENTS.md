# AGENTS.md

Guidance for AI agents working on Typrr.

## Project Overview

Typrr is a standalone typing practice app — single `index.html`, zero dependencies, no build step. Open the file in any browser and it works.

## Architecture

```
index.html          ← Everything: HTML structure, CSS (<style>), JS (<script>)
design.md           ← Design system: tokens, component states, data-viz rules
Makefile            ← `make serve` to run local HTTP server
```

- **No frameworks.** Vanilla HTML/CSS/JS only.
- **No external resources.** No CDN fonts, no icon libraries, no analytics.
- **Single file.** CSS is in `<style>`, JS is in `<script>`. Do not split.
- **localStorage** for persistence. Key: `typrr_data`.

## Data Model

`Store.data` holds all user state:

|Field|Type|Purpose|
|---|---|---|
|`xp`, `level`|number|Gamification progression|
|`streak`, `lastPractice`|number, string|Daily streak tracking|
|`completedLessons`|`{lessonId: {bestWpm, bestAccuracy, stars, attempts}}`|Per-lesson progress|
|`clearedStages`|`number[]`|Stage IDs that passed the test|
|`history`|`Array<{date, themeId, lessonId, stageId, wpm, accuracy, xp, stars, maxCombo, totalChars, errorCount}>`|Session log|
|`errorKeys`|`{key: count}`|Drives the "keys you miss most" panel|
|`badges`|`string[]`|Earned badge IDs|
|`theme`|`"light"｜"dark"｜null`|Explicit colour-scheme choice; `null` follows the OS|

## Theme System

Content is organized into themes, each with sequential stages:

```js
THEMES = { general: { stages: [...] }, go: { stages: [...] }, pt: { stages: [...] } }
THEME_ORDER = ["general", "go", "pt"]
```

- Each stage has `id` (int), `lessons[]`, and optional `test`.
- Lesson IDs are strings like `"1a"`, `"2c"`.
- Progress is global: `completedLessons["1a"]` works across themes.
- `clearedStages` uses integer stage IDs, scoped by current theme.

## UI Conventions

- **CSS variables for all colors.** Reference `design.md` tokens. Never hardcode a colour outside the `:root` / `html[data-theme="dark"]` blocks — a literal in a component rule silently breaks dark mode. Translucent and on-accent surfaces have their own tokens (`--veil`, `--scrim`, `--on-accent`, `--heat-*`) precisely so they can invert.
- **Dark mode is a token swap.** Add the light value to `:root` and the dark value to `html[data-theme="dark"]`; never write a second component rule for dark. The inline `<head>` script resolves the theme before first paint — keep it dependency-free and in sync with `App.resolvedTheme()`.
- **The pull cord owns `--cord-w`.** That token is both the header's right padding and the cord container's width, and it must stay equal to the SVG `viewBox` width (76) — the knob is an HTML button positioned in viewBox units, so scaling the SVG desyncs it from the rope.
- **Three typographic voices.** `--font-display` (slab serif) for titles, `--mono` uppercase for labels, `--font-sans` for body. Do not introduce a fourth.
- **White-first.** Surfaces are `--surface` on `--bg`; separation comes from `--border`, not fills. Saturated accents encode meaning only.
- **`var(--font-sans)`** for UI text, **`var(--mono)`** for code, typing text, metrics and `<kbd>`.
- **Metrics use `font-variant-numeric: tabular-nums`** so values don't jitter.
- **`CSS.escape()`** when building selectors from user/keyboard input.
- **`esc()`** every interpolated string in a template literal before it reaches `innerHTML`.

## Interaction Conventions

- **Every clickable thing is a real `<button>`.** `<button>` accepts only phrasing content, so inner blocks are `<span>` with an explicit `display` rule — a plain span will silently collapse inline.
- **No inline `onclick`.** Markup carries `data-act` / `data-arg` / `data-arg2`; `App.setupDelegation()` wires delegated listeners on `#content`, `#nav`, `#viewNav` and `#breadcrumb`, and `App.dispatch()` routes them. Never use `eval`.
- **One keyboard router.** `App.setupGlobalKeys()` owns every global key, routed in priority order: help overlay → results modal → typing view → global shortcuts. Add new shortcuts there, and document them in `App.toggleHelp()` and the README.
- **Cards opted into keyboard nav** carry `data-nav`. `App.indexNavItems()` assigns the roving tabindex and the `1`–`9` quick-launch numbers; `App.moveFocus()` derives grid rows from live bounding boxes.
- **Views must call `App.setViewChrome(id, crumbs, hints)`** — it syncs the sidebar highlight, breadcrumb, hint bar and nav indexing.
- **Modal keyboard handling lives in the router**, keyed off `App._modalActions`; each action carries a `run()` closure.

## What NOT to Do

- Don't add npm, bundlers, or build tools.
- Don't split into multiple files.
- Don't add external fonts or CDN links — the display stack is system-resident by design.
- Don't use `innerHTML` with unescaped content.
- Don't leave CSS outside the `<style>` block.
- Don't hardcode `#fff`, `white`, `#000`, or any raw color — use CSS variables.
- Don't remove `:focus-visible` styling or add `outline: none` without a replacement.

## Testing

Open `index.html` in a browser. For automated checks:

```bash
make serve           # starts http://localhost:8080
```

Use the browser tool to navigate, type characters, verify modal behavior. Always verify: keyboard-only navigation (`n`, `1`–`9`, arrows, `Esc`, `?`), a full typing session through the results modal, the stats view with seeded history, and **both themes** (`m`) — a hardcoded colour only shows up in dark.

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

|Section|Line|Purpose|
|---|---|---|
|CSS `:root`|12|Light design tokens|
|Dark theme tokens|93|`html[data-theme="dark"]` overrides — values only|
|CSS components|217-1172|All styling, grouped by `/* ── Section ── */` banners|
|Pre-paint theme script|1174|Resolves `data-theme` before first paint|
|Shell markup|1187-1275|Sidebar, header, pull cord, modals, toast|
|`THEMES` data|1280|Content database|
|`BADGES`|1616|Achievement definitions|
|`Store`|1637|localStorage layer|
|`KB_ROWS` / `FINGER_MAP` / `FINGERS`|1677|Keyboard geometry and finger coding|
|`lineChart()` / `heatmap()`|1725 / 1764|Inline SVG data-viz helpers|
|`VIEWS`|1794|View registry + their shortcut keys|
|`PullCord`|1806|Verlet rope theme switch|
|`App`|1996|All game logic|
|`App.init()`|2019|Entry point|
|`App.setViewChrome()`|2128|Breadcrumb, hint bar, nav indexing|
|`App.applyTheme()` / `toggleTheme()`|2235|Dark mode resolution and persistence|
|`App.renderSidebar()`|2165|Sidebar themes + stages|
|`App.showDashboard()`|2295|Dashboard + continue CTA|
|`App.showPerformance()`|2389|Stats view|
|`App.beginTyping()`|2638|Typing engine setup|
|`App.setupGlobalKeys()`|2800|Global keyboard router|
|`App.showResults()`|3130|Results modal|
