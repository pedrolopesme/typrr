# Typrr Design System

White-first, high-contrast, low-chrome. The interface is paper; saturated colour is reserved for meaning — never decoration.

## Principles

1. **White is the default surface.** Cards are white on white, separated by hairline borders, not by fills or heavy shadows.
2. **Colour carries meaning.** Every saturated hue maps to one concept (progress, success, error, warning, finger). If a colour has no meaning, it does not appear.
3. **Numbers are tabular.** All metrics use `font-variant-numeric: tabular-nums` so values don't jitter while typing.
4. **Every action is reachable from the keyboard**, and every focusable element shows where focus is.

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
| `--accent` / `--accent-hover` | `#4f46e5` / `#4338ca` | Primary action, focus, active nav, WPM, caret |
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

| Role | Font | Usage |
|---|---|---|
| UI | `var(--font-sans)` — system stack | Everything except code |
| Code | `var(--mono)` | Typing area, keyboard, previews, metrics, `<kbd>` |

Weights: 800 for page/stat titles, 650–700 for card and panel titles, 400–550 for body. Titles use negative letter-spacing (`-0.3px` to `-1px`); uppercase labels use `+0.6px` to `+0.9px`.

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
- `prefers-reduced-motion: reduce` disables every animation and transition.
