# Morgan's Dotfiles

This is a wraps [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) and adds my customizations after ZSH and OH my ZSH install.

### Installation

#### Prerequisites
ZSH must already be installed:
* MacOs

`brew install zsh`

* Ubuntu

`sudo apt-get install zsh`

Install fabric (python) if not already installed on machine

`pip install fabric`


#### Install
Clone:

`cd ~ && git clone git@github.com:morganwallace/.dotfiles.git ~/.dotfiles`


Then run these commands to install everything:

```
cd .dotfiles
fab install_omz
fab install_plugins
fab install_dotfiles
```
