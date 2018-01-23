import os

from fabric.api import local
from fabric.context_managers import cd

def echo(printStr):
    local('echo "%s"' % (str(printStr)))

def install():
    """Command (idempotent) to setup coding environment."""
    echo('installing oh-my-zsh')
    with cd('~'):
        local('sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')
    local('bash ~/.dotfiles/tools/install.sh')
    echo('\n\n\n Adding Custom Plugins \n\n')
    if not os.path.isdir('~/.dotfiles/custom/plugins'):
        os.makedirs('~/.dotfiles/custom/plugins')
    local('cd ~/.dotfiles/custom/plugins')   
    local('git clone https://github.com/zsh-users/zsh-syntax-highlighting.git')
    local('git clone https://github.com/olivierverdier/zsh-git-prompt.git')
    local('git clone https://github.com/zpm-zsh/autoenv')
    local('source ~/.zshrc')
