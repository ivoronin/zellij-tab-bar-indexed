# zellij-tab-bar-indexed

The default [Zellij](https://zellij.dev/) tab-bar and compact-bar plugins with **one additional feature**: optional tab indices display.

![screenshot](screenshot.png)

## Why This Exists

These plugins are extracts of Zellij's built-in `tab-bar` and `compact-bar` plugins with a single addition: the `show_tab_indices` option that displays numeric indices (`<1>`, `<2>`, etc.) in tab labels.

This feature is proposed upstream in [zellij-org/zellij#4606](https://github.com/zellij-org/zellij/pull/4606). Until the PR is merged, these standalone plugins let you use it today.

**When the PR is merged**, you can switch back to the built-in plugins.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| `tab-bar.wasm` | Standard tab bar with tabs displayed as ribbons |
| `compact-bar.wasm` | Compact bar with mode indicator and tooltip support |

## Installation

### Tab Bar Plugin

In your config (`~/.config/zellij/config.kdl`), find the `plugins` block and replace the `tab-bar` line:

```kdl
plugins {
    // Replace this:
    // tab-bar location="zellij:tab-bar"
    // With this:
    tab-bar location="https://github.com/ivoronin/zellij-tab-bar-indexed/releases/latest/download/tab-bar.wasm" {
        show_tab_indices true
    }
    // ... other plugins
}
```

### Compact Bar Plugin

In your config (`~/.config/zellij/config.kdl`), find the `plugins` block and replace the `compact-bar` line:

```kdl
plugins {
    // Replace this:
    // compact-bar location="zellij:compact-bar"
    // With this:
    compact-bar location="https://github.com/ivoronin/zellij-tab-bar-indexed/releases/latest/download/compact-bar.wasm" {
        show_tab_indices true
    }
    // ... other plugins
}
```

### First Run - Grant Permission

On first launch, the plugins request permission to read application state:

**For tab-bar (top of screen):**
1. Start zellij
2. Press `Ctrl+p` (pane mode)
3. Press `k` to move up to the tab-bar pane
4. Press `Enter` to focus it
5. Press `y` to grant permission

**For compact-bar (bottom of screen):**
1. Start zellij
2. Press `Ctrl+p` (pane mode)
3. Press `j` to move down to the compact-bar pane
4. Press `Enter` to focus it
5. Press `y` to grant permission

Permission persists for future sessions.

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `show_tab_indices` | bool | `false` | Show `<1>`, `<2>`, etc. in tab labels |

### Compact Bar Additional Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `tooltip` | string | - | Key to toggle the tooltip (e.g., `"?"`) |

## Building from Source

```bash
rustup target add wasm32-wasip1
cargo build --release --target wasm32-wasip1
# Outputs:
#   target/wasm32-wasip1/release/tab_bar.wasm
#   target/wasm32-wasip1/release/compact_bar.wasm
```

## License

MIT. Based on the default tab-bar and compact-bar plugins from [zellij-org/zellij](https://github.com/zellij-org/zellij).
