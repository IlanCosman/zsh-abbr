# zsh-snippets

An Oh My Zsh plugin to create aliases that expand.

## Installation

Clone the repository into the Oh My Zsh custom plugins folder:

```sh
git clone https://github.com/IlanCosman/zsh-snippets ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-snippets
```

---

## Commands

### als

```sh
als "gaa" "git add -A"
```

Replacement for traditional alias to provide consistent formatting with the other commands.

### expansion

```sh
expansion "syu" "sudo pacman -Syu"
```

Add a new expansion where `syu + Space` will be replaced with `sudo pacman -Syu`.

```sh
expansion "gca" "git commit -am '^'"
```

Use a `^` in an expansion to determine where the cursor will be placed after pressing `Space`.

### snippet

```sh
snippet "gs" "git status"
```

Functions as both an alias and an expansion. `Enter` will use `gs` as an alias while `Space` will expand the command into `git status`.

- Carrots do not function in snippets
