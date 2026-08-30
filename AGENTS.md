# AGENTS.md

Guidance for AI agents working on Typrr.

## Project Overview

Typrr is a standalone typing practice app — single `index.html`, zero dependencies, no build step. Open the file in any browser and it works.

## Architecture

```
index.html            ← Everything: HTML structure, CSS (<style>), JS (<script>)
manifest.webmanifest  ← Web app manifest
sw.js                 ← Service worker: offline app shell
icons/                ← Source-generated app icons
design.md             ← Design system: tokens, component states, data-viz rules
Makefile              ← `make serve` to run local HTTP server
```

- **No frameworks.** Vanilla HTML/CSS/JS only.
- **No external resources.** No CDN fonts, no icon libraries, no analytics.
- **Single file.** CSS is in `<style>`, JS is in `<script>`. Do not split. The PWA files beside it are deployment assets, not app code — never move app logic into them.
- **`index.html` must open clean on `file://`.** The favicon and sidebar logo are inlined as data URIs, and the manifest link is attached only over `http(s)` because fetching it from `file://` is CORS-blocked and logs errors. Anything you add must keep a lone `index.html` silent and complete.
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
|`enabledKits`|`string[]`|Kit IDs visible in the sidebar; managed by the Kit Hub|

## Typing Kit System

Content is organized into typing kits, each with sequential stages:

```js
THEMES = { general: { stages: [...] }, go: { stages: [...] }, pt: { stages: [...] } }
THEME_ORDER = ["general", "go", "pt"]
```

- Each stage has `id` (int), `lessons[]`, and optional `test`.
- Lesson IDs are strings like `"1a"`, `"2c"`.
- Progress is global: `completedLessons["1a"]` works across kits.
-
The Kit Hub (`k`) groups kits by category (`KIT_CATEGORIES`). `Store.data.enabledKits` tracks which kits appear in the sidebar; the hub toggles them. At least one kit must stay enabled.

## UI Conventions

- **CSS variables for all colors.** Reference `design.md` tokens. Never hardcode a colour outside the `:root` / `html[data-theme="dark"]` blocks — a literal in a component rule silently breaks dark mode. Translucent and on-accent surfaces have their own tokens (`--veil`, `--scrim`, `--on-accent`, `--heat-*`) precisely so they can invert.
- **Dark mode is a token swap.** Add the light value to `:root` and the dark value to `html[data-theme="dark"]`; never write a second component rule for dark. The inline `<head>` script resolves the theme before first paint — keep it dependency-free and in sync with `App.resolvedTheme()`.
- **Sidebar collapse is desktop-scoped.** Keep `html.sidebar-collapsed` rules inside `@media (min-width: 769px)`; unscoped they outrank `.sidebar.open` on specificity and the phone drawer stops opening. `App.autoCollapsed` marks a collapse the app performed for a session — only that one is undone on leaving, so an explicit preference is never clobbered.
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
- Don't let assets 404 or log on `file://`; inline them instead.
- Don't bump the app without bumping `CACHE` in `sw.js`, or returning users keep the cached shell.
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

## Web App

- `manifest.webmanifest` declares name, `display: standalone`, `start_url: ./` and three icons (192 any, 512 any, 512 maskable). Chrome must report zero errors from `Page.getAppManifest` and zero `Page.getInstallabilityErrors`.
- `sw.js` is **network-first for navigations** and cache-first for static assets. Never make the document cache-first: users would be pinned to the build they first visited and every deploy would be swallowed silently. `CACHE` is bumped per release and stale caches are dropped on activate.
- `theme-color` is emitted twice with `prefers-color-scheme` media for first paint, then overridden at runtime by `App.applyTheme()` — the in-app choice can disagree with the OS.
- Icons are generated from a single source logo; see the generator note in the release commit. Regenerate all sizes together so they stay consistent.

## Adding a New Typing Kit

1. Add an entry to `THEMES` with `id`, `name`, `icon`, `desc`, `stages[]`.
2. Add the kit key to `THEME_ORDER`.
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
|CSS `:root`|44|Light design tokens|
|Dark theme tokens|125|`html[data-theme="dark"]` overrides — values only|
|CSS components|249-1202|All styling, grouped by `/* ── Section ── */` banners|
|Head script|1204|Pre-paint theme + `http`-only manifest link|
|Shell markup|1225-1313|Sidebar, header, pull cord, modals, toast|
|`THEMES` data|1318|Content database|
|`BADGES`|1654|Achievement definitions|
|`Store`|1675|localStorage layer|
|`KB_ROWS` / `FINGER_MAP` / `FINGERS`|1715|Keyboard geometry and finger coding|
|`lineChart()` / `heatmap()`|1763 / 1802|Inline SVG data-viz helpers|
|`VIEWS`|1832|View registry + their shortcut keys|
|`PullCord`|1844|Verlet rope theme switch|
|`App`|2034|All game logic|
|`App.init()`|2057|Entry point|
|`App.setViewChrome()`|2166|Breadcrumb, hint bar, nav indexing|
|`App.applyTheme()`|2273|Theme resolution, persistence, `theme-color`|
|`App.renderSidebar()`|2203|Sidebar themes + stages|
|`App.showDashboard()`|2344|Dashboard + continue CTA|
|`App.showPerformance()`|2438|Stats view|
|`App.beginTyping()`|2687|Typing engine setup|
|`App.setupGlobalKeys()`|2849|Global keyboard router|
|`App.showResults()`|3179|Results modal|
