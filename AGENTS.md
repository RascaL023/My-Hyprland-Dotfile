# AGENTS.md

**Purpose:**  
Rapid, mistake-free config sync across systems via the `~/.dotfile` repo and `.synchronizer` script.

---

## Architecture/Entry Points

- **Configs live in:** `~/.dotfile/<tool>` per tool.
- **Symlinks go to:** `~/.config/<tool>`.
- **Single source of truth:** Everything in the repo or listed in `tools.list`.

---

## Key Scripts & Commands

- **Main script:** `.synchronizer/.sync.sh` (pure bash)
  - **Interactive menu:** `bash ~/.dotfile/.synchronizer/.sync.sh`  
    Prompts for password `"atmin123"` (hardcoded, 3 tries).
  - **Direct CLI:**  
    `sync.sh <command> [tool ...]`
    - `link` — move configs into repo & symlink back
    - `restore` — undo (restore configs from repo to original location)
    - `status` — dry-run report.  
      E.g. `sync.sh status cava`, or omit tool for all.

- **Supported tools:** Listed in `tools.list`.  
  (Auto-locates under `~/.config` by tool name unless an explicit path is given.)

---

## State & Metadata

- **Sync state file:** `.synchronizer/state`
  - Maps: tool name → original config location

- **tools.list:**  
  - Format:
    - `tool` (auto-locate dir/file/symlink under config root)
    - `tool:explicit_path` (optional for dotfiles that don’t follow XDG)
  - Blank lines and `#` comments ignored.

---

## Signals & Gotchas

- Each `link` or `restore` will **move the actual config** (not a copy).
- Existing targets in the repo are **backed up with a `.bak-<timestamp>` suffix**.
- Unknown/extra tool names are rejected with `[ERR] unknown tool: <name>`.
- Configs not found in the expected place or not symlinkable → `[ERR]` with reject reason.
- **Menu asks for one or more tools** (space-separated), or return empty to operate on all.

---

## Setup on New Machine

1. `git clone <repo-url> ~/.dotfile`
2. `bash ~/.dotfile/.synchronizer/.sync.sh link`

---

## Style and Workflow

- All config changes and state updates run _only_ through `.sync.sh`.
- Never edit linked configs directly in `~/.config`, always work in `~/.dotfile` then sync.

---

## Existing Documentation

- **This file supersedes:**
  - `README.md` — see there for user-oriented details and the full table of tool mapping.
- **No repo-local OpenCode agent config detected as of this writing.**

---

Ready for use and future agent updates.

---
