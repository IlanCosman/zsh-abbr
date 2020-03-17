# zsh-abbr

A Fish shell-like [abbr](https://fishshell.com/docs/current/cmds/abbr.html) command for Zsh with extended cursor placement functionality.

## Installation

1. Clone the repository into the Oh My Zsh custom plugins folder:

   ```sh
   git clone https://github.com/IlanCosman/zsh-abbr $ZSH_CUSTOM/plugins/zsh-abbr
   ```

2. Add `zsh-abbr` to the plugins array in your zshrc:

   ```sh
   plugins=(... zsh-abbr)
   ```

## Examples

```sh
abbr syu="sudo pacman -Syu"
```

`Space` will expand `syu` into `sudo pacman -Syu`. `Enter` will expand and then run the command.

```sh
abbr gca="git commit -am '^'"
```

Use a `^` to determine where the cursor will be placed after expansion.

**Note:** Using a `^` will cause `Enter` to only expand the command, not run it.
