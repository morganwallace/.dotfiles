import os
import shutil

from fabric.api import local
from fabric.context_managers import cd


HOME = os.path.expanduser('~')
OMZ_PATH = os.path.join(HOME, '.oh-my-zsh')
DOTFILES_PATH = os.path.join(HOME, '.dotfiles')
ZSHRC_FILE_PATH = os.path.join(HOME, '.zshrc')
DOTFILES_PLUGINS_PATH = os.path.join(DOTFILES_PATH, 'custom', 'plugins')


def echo(print_str):
    local('echo "%s"' % (str(print_str)))


def omz():
    echo('installing oh-my-zsh')

    # Check to see if omz exists already
    try:
        shutil.rmtree(OMZ_PATH)
    except:
        pass
    try:
        os.remove(ZSHRC_FILE_PATH)
    except:
        pass
    try:
        local('rm -rf %s' % (os.path.join(HOME, '.zsh*')))
    except:
        pass
    with cd(HOME):
        local('sh -c "$(curl -fsSL \
            https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')


def dotfiles():
    """Setup custom stuff on top of omz."""
    try:
        local('ln -sf %s %s' % (os.path.join(DOTFILES_PATH, 'custom'),
                                os.path.join(OMZ_PATH, 'custom', 'morgans_custom')))
        local('cp %s %s' %
              (os.path.join(DOTFILES_PATH, 'templates', 'zshrc.zsh-template'),
               ZSHRC_FILE_PATH))
        local('cp {} {}'.format(os.path.join(DOTFILES_PATH, '.gitignore_global')))
    except:
        pass
    local('bash %s' % (os.path.join(DOTFILES_PATH, 'tools', 'install.sh')))


def get_vq_aliases():
    if os.path.exists('/srv/volta'):
        local('ln -sf /srv/volta/vq* %s' %
              (os.path.join(OMZ_PATH, 'custom', 'morgans_custom')))


def plugins():
    if not os.path.exists(DOTFILES_PLUGINS_PATH):
        os.makedirs(DOTFILES_PLUGINS_PATH)
    zsh_highlighting_path = os.path.join(
        DOTFILES_PLUGINS_PATH, 'zsh-syntax-highlighting')
    if not os.path.exists(zsh_highlighting_path):
        local('git clone https://github.com/zsh-users/zsh-syntax-highlighting.git %s' %
              (zsh_highlighting_path))

def uninstall():
    local('bash %s' % os.path.join(OMZ_PATH, 'tools', 'uninstall.sh'))
