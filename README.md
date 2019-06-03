# Morgan's Dotfiles

This wraps [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) and adds my customizations after ZSH and OH my ZSH install.

## Installation

#### Prerequisites
ZSH must already be installed:
* MacOs

`brew install zsh`

* Ubuntu

`sudo apt-get install zsh`


#### Install


`sh -c "$(curl -fsSL https://raw.githubusercontent.com/morganwallace/.dotfiles/master/install.sh)"`


### Private aliases (not within source control)
To keep aliases outside version control but have them installed and sourced automatically, place them in your `$HOME` directory and the name must match the wildcard statement:
`$HOME/*aliases*.zsh` 
