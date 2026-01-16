# zellij-tab-bar-indexed

Tab-bar plugin for [Zellij](https://zellij.dev/) with optional tab indices display.

## Features

- **Tab Indices**: Display indices (`<1>`, `<2>`, etc.) for keyboard navigation
- Click-to-switch, scroll wheel navigation
- Full theme support

## Installation

Add to your layout (`~/.config/zellij/layouts/default.kdl`):

```kdl
layout {
    default_tab_template {
        pane size=1 borderless=true {
            plugin location="https://github.com/ivoronin/zellij-tab-bar-indexed/releases/latest/download/tab-bar.wasm" {
                show_tab_indices true
            }
        }
        children
        pane size=2 borderless=true {
            plugin location="zellij:status-bar"
        }
    }
}
```

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `show_tab_indices` | bool | false | Show tab index numbers |
| `hide_swap_layout_indication` | bool | false | Hide swap layout indicator |

## Building from Source

```bash
rustup target add wasm32-wasip1
cargo build --release --target wasm32-wasip1
```

## License

MIT - Based on the default tab-bar plugin from [Zellij](https://github.com/zellij-org/zellij).
