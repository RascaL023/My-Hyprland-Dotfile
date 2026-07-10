# My Hyprland Dotfile

Personal Hyprland dotfiles with a simple symlink-based **Synchronizer**.

Configs live in this repo (`~/.dotfile`) and are symlinked back into
`~/.config`, so everything stays version-controlled in one place.

## Environment

- **OS:** NixOS
- **WM:** Hyprland (Wayland)
- **Shell:** fish (bash fallback)

## Included Configs

| Tool     | Description            |
|----------|------------------------|
| kitty    | Terminal emulator      |
| foot     | Terminal emulator      |
| cava     | Audio visualizer       |
| hypr     | Hyprland compositor    |
| waybar   | Status bar             |
| eww      | Widgets                |
| wlogout  | Logout menu            |
| rofi     | App launcher           |
| nvim     | Editor                 |
| yazi     | File manager           |

The full list is defined in [`tools.list`](tools.list).

## How It Works

The synchronizer moves each real config from `~/.config/<tool>` into
`~/.dotfile/<tool>`, then creates a symlink back at the original location.
A state file (`.synchronizer/state`) records each tool's original path so
restores are precise even for non-standard locations.

## Usage

The script lives at `.synchronizer/.sync.sh` and runs with **bash**.

### Interactive mode

```bash
bash ~/.dotfile/.synchronizer/.sync.sh
```

You'll be asked for a password, then shown a menu:

```
1. Start linkings   # move configs into the repo and symlink them back
2. Restore links    # undo: move configs back to their origin
3. Status           # dry-run report, changes nothing
4. Clear            # clear the screen
0. Exit
```

After choosing `1`, `2`, or `3` you'll be prompted for a target:

```
Target (kosong = semua): 
```

- Leave empty → apply to **all** tools.
- Type a name (e.g. `cava`) → apply to that tool only.
- Space-separated names (e.g. `cava foot hypr`) → apply to several tools.

### Non-interactive mode (CLI)

```bash
sync.sh <command> [tool ...]
```

| Command   | Example                         | Action                         |
|-----------|---------------------------------|--------------------------------|
| `link`    | `sync.sh link`                  | Link all tools                 |
| `link`    | `sync.sh link cava`             | Link a single tool             |
| `link`    | `sync.sh link cava foot hypr`   | Link several tools             |
| `restore` | `sync.sh restore hypr`          | Restore a tool to its origin   |
| `status`  | `sync.sh status`                | Report status of all tools     |
| `status`  | `sync.sh status cava`           | Report status of one tool      |

No tool argument means **all tools**. Unknown tools are rejected with
`[ERR] unknown tool: <name>`.

### Status states

| State                | Meaning                                             |
|----------------------|-----------------------------------------------------|
| `LINKED`             | Symlinked to `~/.dotfile` (all good)                |
| `STAGED (not linked)`| Present in `~/.dotfile` but symlink not in place    |
| `NOT LINKED`         | Still the original config in `~/.config`            |
| `MISSING`            | Not found anywhere                                  |

## `tools.list` format

Blank lines and lines starting with `#` are ignored.

```
# auto-locate under ~/.config
kitty
hypr

# explicit path (supports ~) for non-standard locations
zsh:~/.zshrc
```

- `name` → auto-locates a file/dir/symlink named `name` under
  `$XDG_CONFIG_HOME` (defaults to `~/.config`).
- `name:path` → uses an explicit source path.

## Setup on a new machine

```bash
git clone <repo-url> ~/.dotfile
bash ~/.dotfile/.synchronizer/.sync.sh link
```

This symlinks every config from the repo into place.
