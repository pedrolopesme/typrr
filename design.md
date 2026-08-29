# Typrr Design System

White-first, high-contrast, low-chrome. The interface is paper; saturated colour is reserved for meaning — never decoration. A dark theme inverts the ink without changing any of those meanings.

## Principles

1. **White is the default surface.** Cards are white on white, separated by hairline borders, not by fills or heavy shadows.
2. **Colour carries meaning.** Every saturated hue maps to one concept (progress, success, error, warning, finger). If a colour has no meaning, it does not appear.
3. **Numbers are tabular.** All metrics use `font-variant-numeric: tabular-nums` so values don't jitter while typing.
4. **Every action is reachable from the keyboard**, and every focusable element shows where focus is.
5. **Titles speak in slab-serif.** The display face carries the typewriter voice; labels are letterspaced mono small caps; body copy stays in the neutral system sans.
6. **No literal colours outside `:root`.** Every component reads a token, which is what makes the dark theme a pure token swap.

## Neutrals

| Token | Hex | Usage |
|---|---|---|
| `--bg` | `#ffffff` | Page background |
| `--bg-subtle` | `#fbfcfd` | Sidebar, empty states, disabled cards |
| `--surface` | `#ffffff` | Cards, panels, modals, keys |
| `--surface-alt` | `#f4f6f9` | Inset blocks: code previews, timer, table zebra |
| `--surface-sunken` | `#eaeef3` | Empty progress tracks, unfilled stars |
| `--border` | `#e4e8ee` | Hairline borders and dividers |
| `--border-strong` | `#c9d1dc` | Hover borders, key bottom edge |
| `--text` | `#101828` | Primary text, typed characters |
| `--text-dim` | `#4a5567` | Secondary text, body copy |
| `--text-muted` | `#808b9d` | Labels, hints, axis ticks |

## Accents

Each accent ships as a **text colour** (AA on white) and a **soft tint** for backgrounds. `-fill` variants are bright colours only used for large shapes, never for small text.

| Token | Hex | Meaning |
|---|---|---|
| `--accent` / `--accent-hover` | `#4f46e5` / `#4338ca` | Primary action, focus, active nav, WPM, next-key block |
| `--accent-soft` | `#eef1ff` | Active-state and next-key backgrounds |
| `--green` / `--green-soft` | `#047857` / `#e6f7f1` | Correct input, accuracy, cleared stages |
| `--red` / `--red-soft` | `#d81b48` / `#ffedf1` | Errors, missed keys, failed targets |
| `--amber` / `--amber-fill` / `--amber-soft` | `#b45309` / `#f59e0b` / `#fff5e5` | Streaks, stage tests, combo, chart peak |
| `--cyan` / `--cyan-soft` | `#0e7490` / `#e5f6fb` | Informational stats, NEW badges |
| `--violet` / `--violet-soft` | `#6d28d9` / `#f3efff` | XP and level progression |
| `--pink` / `--pink-soft` | `#be185d` / `#fdeef5` | Peak combo tier, badge stats |
| `--gold` / `--gold-fill` | `#ca8a04` / `#eab308` | Star glyphs (small / large) |

## Finger Colour Coding

Applied as a 3px bar across the top of each virtual key and as the hand diagram bars.

| Finger | Token | Hex |
|---|---|---|
| Left pinky | `--f-l5` | `#dc2626` |
| Left ring | `--f-l4` | `#ea580c` |
| Left middle | `--f-l3` | `#16a34a` |
| Left index | `--f-l2` | `#0891b2` |
| Right index | `--f-r2` | `#4f46e5` |
| Right middle | `--f-r3` | `#db2777` |
| Right ring | `--f-r4` | `#ca8a04` |
| Right pinky | `--f-r5` | `#7c3aed` |
| Thumb | `--f-thumb` | `#64748b` |

## Typography

Three voices, each with one job.

| Role | Token | Stack | Usage |
|---|---|---|---|
| Display | `--font-display` | `American Typewriter`, `Rockwell`, `Bookman Old Style`, `Iowan Old Style`, Georgia, serif | Brand, page/lesson/modal/card/panel titles, countdown |
| Label | `--mono` | `SF Mono`, `Cascadia Code`, `Fira Code`, `Consolas`, monospace | Uppercase letterspaced small caps: section titles, stat labels, table headers, eyebrows |
| Body | `--font-sans` | system stack | Paragraphs, descriptions, buttons, nav |
| Code | `--mono` | as above | Typing area, keyboard caps, previews, metrics, `<kbd>` |

The display stack is a slab serif on purpose: it is the typewriter in the product. Every face is already on the system — no webfonts, no CDN, no layout shift.

Weights: 700 on display (the slab is heavy enough without 800), 600–650 on labels, 400–550 on body. Display titles sit near `0` tracking; mono labels open up to `+0.5px` to `+1.2px`; numerals stay tabular.

## Inverting Surfaces

Some surfaces are translucent or sit on top of an accent, so they cannot be derived from the flat tokens. They get their own tokens and are redefined per theme:

| Token | Light | Purpose |
|---|---|---|
| `--scrim` | `rgba(16,24,40,0.36)` | Modal backdrop |
| `--veil` / `--veil-solid` | translucent white | Sticky header, hint bar, focus prompt, countdown |
| `--on-accent` | `#ffffff` | Text and icons sitting on `--accent` |
| `--on-accent-veil` / `--on-accent-line` | white at 18% / 28% | `<kbd>` chips inside accent-filled buttons |
| `--accent-cast` / `--accent-cast-strong` | indigo at 25% / 32% | Coloured shadow under the continue banner |
| `--char-pending` | `#a3adbb` | Not-yet-typed characters |
| `--earned-tint` | `#fffdf5` | Top of the earned-badge gradient |
| `--heat-1`…`--heat-4` | indigo ramp | Practice heatmap steps |
| `--cord-ink` | `rgba(127,127,127,0.45)` | Pull-cord rope stroke |
| `--cord-knob-a` / `--cord-knob-b` / `--cord-knob-line` | white → `#e7e7ec` | Pull-cord knob gradient and rim |

## Dark Theme

`html[data-theme="dark"]` redefines the token values only — no component rule is duplicated. Neutrals become a cool ink scale (`#0e1116` → `#eef2f7`), accents brighten for dark backgrounds (`--accent` becomes `#8f8cff`, `--green` `#34d399`, `--red` `#fb7185`), `--on-accent` flips to near-black, and shadows deepen.

Resolution order, applied by an inline script in `<head>` before first paint so nothing flashes:

1. `Store.data.theme` when it is `"light"` or `"dark"` — an explicit user choice always wins.
2. Otherwise `prefers-color-scheme`, re-evaluated on every load.

The toggle only ever writes an explicit value, so a user who never touches it keeps following their OS.

## Brand Mark

The logo is a gradient "T" whose darkest ink is `#081b4e`, so it would vanish on the dark surface. It therefore keeps a **light ground in both themes** — a white rounded tile — rather than being recoloured per theme. The same tile is the favicon, the app icon and the apple-touch icon, so the mark is identical everywhere it appears.

App icons place the logo at 76% of the tile; the maskable variant drops to 54% so it survives the 80% safe-zone crop. The favicon and the sidebar mark are inlined as data URIs so a standalone `index.html` still renders complete.

## The Pull Cord

The theme switch is a ceiling cord hanging in its own lane at the far right of the header — the last control on the row, after everything else.

- **The rope is a Verlet simulation**, not an animation: 16 points, gravity `1250`, damping `0.94`, 20 constraint passes per frame, `26` units of stretch past rest. It hangs, swings and settles.
- **It trips mid-pull.** Dragging past `REST + 15` fires the toggle once per grab, the way a real ceiling chain clicks before you let go. A shorter tug does nothing.
- **Click, `Enter`, `Space` and `m`** all yank the cord: the knob gets a real downward velocity, so every input produces the same physical response.
- **The loop sleeps.** Once the rope settles the `requestAnimationFrame` loop stops; interaction wakes it. A typing app must not hold a frame loop behind the typing engine.
- **Layout invariant:** `--cord-w` must equal the SVG `viewBox` width. The knob is an HTML button positioned in viewBox units, so any scaling of the SVG would drift it away from the rendered rope end.
- `prefers-reduced-motion: reduce` starts the rope at rest and skips the drop-in entrance.

## Spacing, Radii, Elevation

| Token | Value | Usage |
|---|---|---|
| `--radius` | `14px` | Cards, panels, modals, keyboard |
| `--radius-sm` | `10px` | Buttons, live stats, inset blocks |
| `--radius-xs` | `6px` | Nav items, chips, small keys |
| `--shadow-xs` | `0 1px 2px rgba(16,24,40,0.05)` | Active nav item |
| `--shadow-md` | `0 4px 12px rgba(16,24,40,0.08)` | Card hover |
| `--shadow-lg` | `0 16px 40px rgba(16,24,40,0.14)` | Modals, toasts, mobile drawer |

## Component States

| State | Background | Text | Border |
|---|---|---|---|
| Default | `--surface` | `--text-dim` | `--border` |
| Hover | `--surface` | `--text` | `--border-strong` + `--shadow-md` |
| Active / selected | `--accent` | `#fff` | `--accent` |
| Focus visible | unchanged | unchanged | `2px solid --accent`, `2px` offset |
| Next key | `--accent` | `--on-accent` | none — a filled block, no outline |
| Correct | `--green-soft` | `--green` | `--green` |
| Error | `--red-soft` | `--red` | `--red` |
| Disabled / locked | `--bg-subtle` | `--text-muted` | `--border`, `cursor: not-allowed` |

## Data Visualisation

- **Line charts** are inline SVG on a `640×190` viewBox, scaled to the panel. Three gridlines (min / mid / max), a dashed average line, an amber dot on the peak, and a `<title>` tooltip per point.
- **Progress** is always a 4–6px track: `--surface-sunken` empty, `--accent` filling, `--green` when complete.
- **The practice heatmap** uses five indigo steps: `--surface-sunken`, `#c7d2fe`, `#a5b4fc`, `#818cf8`, `--accent`.
- **Deltas** compare the last 5 sessions against the previous 5: `▲` green up, `▼` red down.

## Accessibility

- Text/background pairs meet WCAG AA (≥ 4.5:1); large glyphs and non-text indicators meet ≥ 3:1.
- `:focus-visible` is styled globally and never removed. A skip link jumps to `#content`.
- All interactive elements are real `<button>` elements — `<button>` accepts only phrasing content, so inner blocks are `<span>` with an explicit `display`.
- Colour is never the only signal: icons, text labels and the wavy underline on mistyped characters accompany it.
- The next key to press is a filled block over the whole glyph rather than a caret beside it, so the target is unambiguous. It is painted with padding cancelled by an equal negative margin, which grows the box without reflowing the line on every keystroke.
- The dark theme is a real palette, not a CSS filter: contrast ratios are checked per token, not inherited from an inversion.
- `prefers-reduced-motion: reduce` disables every animation and transition.
