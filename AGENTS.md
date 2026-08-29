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

- **CSS variables for all colors.** Reference `design.md` tokens. Never hardcode hex outside `:root`.
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
- Don't add external fonts or CDN links.
- Don't use `innerHTML` with unescaped content.
- Don't leave CSS outside the `<style>` block.
- Don't hardcode `#fff`, `white`, `#000`, or any raw color — use CSS variables.
- Don't remove `:focus-visible` styling or add `outline: none` without a replacement.

## Testing

Open `index.html` in a browser. For automated checks:

```bash
make serve           # starts http://localhost:8080
```

Use the browser tool to navigate, type characters, verify modal behavior. Always verify: keyboard-only navigation (`n`, `1`–`9`, arrows, `Esc`, `?`), a full typing session through the results modal, and the stats view with seeded history.

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
|CSS `:root`|11|Design tokens|
|CSS components|126-1015|All styling, grouped by `/* ── Section ── */` banners|
|Shell markup|1018-1097|Sidebar, header, hint bar, modals, toast|
|`THEMES` data|1103|Content database|
|`BADGES`|1439|Achievement definitions|
|`Store`|1460|localStorage layer|
|`KB_ROWS` / `FINGER_MAP` / `FINGERS`|1499|Keyboard geometry and finger coding|
|`lineChart()` / `heatmap()`|1547 / 1586|Inline SVG data-viz helpers|
|`VIEWS`|1616|View registry + their shortcut keys|
|`App`|1626|All game logic|
|`App.init()`|1649|Entry point|
|`App.setViewChrome()`|1756|Breadcrumb, hint bar, nav indexing|
|`App.renderSidebar()`|1793|Sidebar themes + stages|
|`App.showDashboard()`|1902|Dashboard + continue CTA|
|`App.showPerformance()`|1996|Stats view|
|`App.beginTyping()`|2245|Typing engine setup|
|`App.setupGlobalKeys()`|2407|Global keyboard router|
|`App.showResults()`|2735|Results modal|
