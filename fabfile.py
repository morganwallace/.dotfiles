import os
import shutil
import subprocess

from fabric.api import local, env, run
from fabric.context_managers import cd


home = os.path.expanduser('~')
omz_path = os.path.join(home, '.oh-my-zsh')
dotfiles = os.path.join(home, '.dotfiles')
zshrc_file = os.path.join(home, '.zshrc')

def echo(printStr):
    local('echo "%s"' % (str(printStr)))

def install_omz():
    echo('installing oh-my-zsh')

    # Check to see if omz exists already
    try:
        shutil.rmtree(omz_path)
    except:
        pass
    try:
        os.remove(zshrc_file)
    except:
        pass
    try:
        local('rm -rf %s' % (os.path.join(home, '.zsh*')))
    except:
        pass
    with cd(home):
        local('sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')

def install_dotfiles():
    """Setup custom stuff on top of omz."""
    try:
        # local('rm -rf %s' % (os.path.join(omz_path, 'custom')))
        local('ln -sf %s %s'  % (os.path.join(dotfiles, 'custom'), os.path.join(omz_path, 'custom', 'morgans_custom')))
        local('cp %s %s' %\
            (os.path.join(dotfiles, 'templates', 'zshrc.zsh-template'),
            zshrc_file))
    except:
        pass
    local('bash %s' % (os.path.join(dotfiles, 'tools', 'install.sh')))

def get_vq_aliases():
    if os.path.exists('/srv/volta'):
        local('ln -sf /srv/volta/vq* %s' % (os.path.join(omz_path, 'custom', 'morgans_custom')))


def install_plugins():
    dotfiles_plugins_path = os.path.join(dotfiles, 'custom', 'plugins')
    if not os.path.exists(dotfiles_plugins_path):
        os.makedirs(dotfiles_plugins_path)
    zsh_highlighting_path = os.path.join(dotfiles_plugins_path, 'zsh-syntax-highlighting')
    if not os.path.exists(zsh_highlighting_path):
        local('git clone https://github.com/zsh-users/zsh-syntax-highlighting.git %s' %\
            (zsh_highlighting_path))
