# Terminal configuration

WezTerm and Starship configuration for macOS.

- Japanese font fallback: Hiragino Kaku Gothic ProN
- Translucent integrated title/tab bar
- Blue directory and green Git branch segments with slanted edges
- Node.js version and account/email omitted from the prompt

## Setup

Install WezTerm and Starship. Back up existing settings before copying:

```sh
mkdir -p ~/.config/wezterm
cp wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
cp starship.toml ~/.config/starship.toml
```

Add to the end of `~/.zshrc`:

```sh
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
```

Open a new terminal tab. Git branch appears only inside Git repositories.
Japanese font fallback requires macOS Hiragino; adjust the font on other systems.
Git status in WezTerm's right status bar supports local panes with Git on PATH.
