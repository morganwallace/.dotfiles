# Morgan's Dotfiles

This wraps [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) and adds customizations after ZSH and OH-MY-ZSH install.

### Features
- Opinionated configuration of oh-my-zsh with plugins
- Improved prompt with:
    - Left Prompt: [3 closest parent directories]
    - Syntax highlighting of commands
    - Right Prompt: Git status
- Opinionated configurations for:
    - VS Code
    - Vim
    - .gitignore-global
- Aliases
- Commands (`bin/`)
- Customizable
    - Put new zsh aliases in `/custom`

## Installation

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/morganwallace/.dotfiles/master/bin/install_files)"`


### Private aliases (not within source control)
To keep aliases outside version control but have them installed and sourced automatically, place them in your `$HOME/.private_aliases/` directory.
