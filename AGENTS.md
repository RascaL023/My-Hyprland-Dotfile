# AGENTS.md

**Purpose:**
Rapid, mistake-free config sync across systems via the `~/.dotfile` repo and the
`.synchronizer` script, plus the matugen-based theming pipeline that keeps every
tool on one semantic palette.

---

## Ground Rules (read first)

- **Edit configs only inside `~/.dotfile`.** Never edit the symlinked
  `~/.config/<tool>` copies directly — they are the same files.
- **Do not run `.synchronizer/.sync.sh`** unless the user explicitly asks; it
  *moves* real configs on disk.
- **Do not commit or push** unless the user explicitly asks.
- Directories named `.private/` (e.g. `matugen/.private/`, `nvim/.private/`) are
  git-ignored scratch/session notes — not a source of truth.
- Generated artifacts are machine-written, never hand-edit them. Change the
  source/template, then re-render:
  - `matugen/generated.bak/` (ignored)
  - `~/.myenv/theme/generated/**` (outside the repo)
  - `nvim/lua/core/generated/**`

---

## Architecture / Entry Points

- **Configs live in:** `~/.dotfile/<tool>`; **symlinks point from** `~/.config/<tool>`.
- **Single source of truth:** the repo, plus the tool names listed in `tools.list`.
- **Theming source of truth:** `matugen/` (see [Theming](#theming-matugen)).
- **Agent-facing docs:** `AGENTS.md` (this file) and `matugen/docs/`.

---

## Key Scripts & Commands

### Config sync — `.synchronizer/.sync.sh` (pure bash)

- **Interactive menu:** `bash ~/.dotfile/.synchronizer/.sync.sh`
  Prompts for password `"atmin123"` (hardcoded, 3 tries).
- **Direct CLI:** `sync.sh <command> [tool ...]`
  - `link` — move configs into the repo and symlink them back
  - `restore` — undo (move configs from the repo back to their original location)
  - `status` — dry-run report (e.g. `sync.sh status cava`, or omit tool for all)
- Supported tools come from `tools.list`; auto-located under `~/.config` by name
  unless an explicit path is given.

### Theming — matugen

- Wallpaper theme: `matugen image <wallpaper> --source-color-index 0 -c ~/.config/matugen/config.toml`
- Fixed domain palette: `matugen json <palette.json> -c <per-theme config>`
- Details, gotchas and testing recipes: `matugen/docs/MATUGEN_SKILLS.md`.

---

## State & Metadata

- **Sync state file:** `.synchronizer/state.tmp` — maps `tool` → original config path.
- **`tools.list`:**
  - `tool` (auto-locate dir/file/symlink under the config root)
  - `tool:explicit_path` (for dotfiles outside XDG, e.g. `matugen:~/.config/matugen`)
  - Blank lines and `#` comments are ignored.

---

## Theming (matugen)

Two independent flows live under `matugen/`. Pick the right one.

### 1. Wallpaper-derived ("general")

- Config: `matugen/config.toml`
- Templates: `matugen/templates/general/*`, using Material roles `{{ colors.<role>.default.hex }}`
- Render: `matugen image <wallpaper> --source-color-index 0 -c ~/.config/matugen/config.toml`
- Output: `~/.myenv/theme/generated/live.bak/<tool>/...`

### 2. Fixed domain palette (named theme, e.g. `kanagawa-dragon`)

- **Source palette:** `matugen/templates/<theme>/blueprint/palette.json` — a
  hand-authored (not matugen-generated) JSON with `dark` and `light` blocks:
  `background`, `foreground`, `cursor`, `colors` (16-entry ANSI array) and
  `extra` = `{ accent, text, layer, border, status, fg, bg, syntax, ui }`.
  `extra.syntax` uses **universal semantic names** (`comment`, `keyword`,
  `function`, `string`, ...) so every tool maps from the same vocabulary.
- **Templates:** `matugen/templates/<theme>/template/*`
- **Render:** `matugen json <palette.json> -c <per-theme config>` — the JSON is
  exposed at the template root, so templates read `{{ dark.* }}` / `{{ light.* }}`.
- **Config:** use a **separate config per theme**. Do not add these to
  `matugen/config.toml`; that config powers `matugen image` runs and would fail
  without a `dark`/`light` root.
- **Output:** `~/.myenv/theme/generated/<theme>/<tool>/...`

---

## nvim theme

- `nvim/lua/core/theme.lua` is the **single source of truth** for nvim colours: it
  loads the generated palette, maps it onto tokyonight keys, and owns every plugin
  highlight group. Do not hardcode hex outside the generated palette file.
- **Generated palette:** `nvim/lua/core/generated/kanagawa.lua` (rendered from
  `matugen/templates/kanagawa-dragon/template/nvim.lua`), required as
  `require("core.generated.kanagawa")` → `{ dark = ..., light = ... }`.
- Keep **palette data** (generated) separate from the **mapping logic** on purpose:
  the tokyonight key mapping, `blend()` math and plugin highlights live in
  `theme.lua`, because matugen's template engine cannot do colour arithmetic.
- Current mode: **dark** (Kanagawa Dragon). The `light` block is generated and
  ready but not yet wired.

---

## Signals & Gotchas

- Each `link`/`restore` **moves** the real config (not a copy).
- Existing repo targets are backed up with a `.bak-<timestamp>` suffix.
- Unknown tool names → `[ERR] unknown tool: <name>`; missing/unlinkable configs →
  `[ERR]` with the reject reason.
- The menu accepts one or more tools (space-separated); empty = all tools.

---

## Setup on a New Machine

1. `git clone <repo-url> ~/.dotfile`
2. `bash ~/.dotfile/.synchronizer/.sync.sh link`
3. Re-render generated artifacts that are not committed (e.g. the nvim palette
   module) — see `matugen/docs/MATUGEN_SKILLS.md`.

---

## Documentation

- `README.md` — user-oriented sync details, status states and the full tool table.
- `matugen/docs/MATUGEN_SKILLS.md` — build/register/test matugen templates
  (wallpaper flow **and** the fixed-palette flow, with verified engine gotchas).
- `matugen/docs/PROGRESS.md` — which tools already have matugen templates.
- `matugen/docs/VOCABULARY.md` / `matugen/docs/CHEATSHEETS.md` — matugen role
  vocabulary and semantic mapping cheat sheet.
- `AGENTS.md` (this file) — agent rules and repo map.

---

Ready for use and future agent updates.
