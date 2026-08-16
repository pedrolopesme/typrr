# Typrr Design System

Based on the [Dracula](https://draculatheme.com) color palette — dark, vibrant, high-contrast.

## Color Palette

| Token | Dracula Name | Hex | Usage |
|-------|-------------|-----|-------|
| `--bg` | Background | `#282a36` | Page background |
| `--bg-card` | Current Line | `#44475a` | Cards, sidebar, elevated surfaces |
| `--bg-card-hover` | Selection | `#44475a` + opacity | Hover states |
| `--border` | Comment (dim) | `#3a3d50` | Borders, dividers |
| `--text` | Foreground | `#f8f8f2` | Primary text |
| `--text-dim` | Comment | `#8494cc` | Secondary text, labels |
| `--text-muted` | Comment (dim) | `#7c88ad` | Disabled, hints |
| `--accent` | Purple | `#d4b8fd` | Primary actions, links, active states |
| `--accent-glow` | Purple 15% | `rgba(212,184,253,0.15)` | Subtle backgrounds, glows |
| `--green` | Green | `#50fa7b` | Correct, success, XP |
| `--green-dim` | Green 12% | `rgba(80,250,123,0.12)` | Success backgrounds |
| `--red` | Red | `#ff5555` | Errors, incorrect |
| `--red-dim` | Red 12% | `rgba(255,85,85,0.12)` | Error backgrounds |
| `--orange` | Orange | `#ffb86c` | Warnings, streaks, test badges |
| `--orange-dim` | Orange 12% | `rgba(255,184,108,0.12)` | Warning backgrounds |
| `--blue` | Cyan | `#8be9fd` | Info, links |
| `--blue-dim` | Cyan 12% | `rgba(139,233,253,0.12)` | Info backgrounds |
| `--gold` | Yellow | `#f1fa8c` | Stars, XP bars, achievements |
| `--pink` | Pink | `#ff79c6` | Highlights, badges |

## Finger Color Coding (Keyboard)

Each finger gets a distinct color for the typing guide:

| Finger | Color | Hex |
|--------|-------|-----|
| Left Pinky | Red (warm) | `#ff6e6e` |
| Left Ring | Orange | `#ffb86c` |
| Left Middle | Green | `#50fa7b` |
| Left Index | Cyan | `#8be9fd` |
| Right Index | Purple | `#d4b8fd` |
| Right Middle | Pink | `#ff79c6` |
| Right Ring | Yellow | `#f1fa8c` |
| Right Pinky | Red | `#ff5555` |

## Typography

| Role | Font | Usage |
|------|------|-------|
| Body/UI | `-apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui` | Buttons, labels, nav |
| Display | `'Georgia', 'Iowan Old Style', serif` | Headlines (optional, see note) |
| Code | `'SF Mono', 'Cascadia Code', 'Fira Code', 'Consolas', monospace` | Typing area, keyboard, code snippets |

> **Note:** Sans-serif is primary for readability. Serif is optional for display headings only.

## Spacing & Radii

| Token | Value | Usage |
|-------|-------|-------|
| `--radius` | `14px` | Cards, modals |
| `--radius-sm` | `10px` | Buttons, inputs, badges |
| `--shadow` | `0 2px 8px rgba(0,0,0,0.25)` | Cards |
| `--shadow-lg` | `0 8px 24px rgba(0,0,0,0.3)` | Modals, elevated |

## Component States

| State | Background | Text | Border |
|-------|-----------|------|--------|
| Default | `--bg-card` | `--text-dim` | `--border` |
| Hover | `--bg-card-hover` | `--text` | `--accent` |
| Active/Selected | `--accent-glow` | `--accent` | `--accent` |
| Correct | `--green-dim` | `--green` | `--green` |
| Error | `--red-dim` | `--red` | `--red` |
| Locked | `--bg-card` (50% opacity) | `--text-muted` | `--border` |

## Accessibility

- All text/background pairs maintain ≥ 4.5:1 contrast ratio (WCAG AA)
- Focus indicators use `--accent` with visible outline
- Keyboard shortcuts shown in `<kbd>` elements
- Color is never the sole indicator — icons and text labels accompany status
