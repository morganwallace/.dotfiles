#!/bin/bash
# Most of this script comes directly from the oh-my-zsh install script.
# All customizations beyond that are at the bottom.

main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if ! command -v zsh >/dev/null 2>&1; then
    printf "${YELLOW}Zsh is not installed!${NORMAL} Please install zsh first!\n"
    if ! command -v apt-get >/dev/null 2>&1; then
      sudo apt-get install zsh
    fi
    if ! command -v brew >/dev/null 2>&1; then
      brew install zsh
    fi
    if ! command -v zsh >/dev/null 2>&1; then
      printf "ZSH was not able to be install automatically. See\nhttps://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH#install-and-set-up-zsh-as-default"
    fi
  fi

  if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
  fi

  if [ ! -d "$ZSH" ]; then
    # Prevent the cloned repository from having insecure permissions. Failing to do
    # so causes compinit() calls to fail with "command not found: compdef" errors
    # for users with insecure umasks (e.g., "002", allowing group writability). Note
    # that this will be ignored under Cygwin by default, as Windows ACLs take
    # precedence over umasks except for filesystems mounted with option "noacl".
    umask g-w,o-w

    printf "${BLUE}Cloning Oh My Zsh...${NORMAL}\n"
    command -v git >/dev/null 2>&1 || {
      echo "Error: git is not installed"
      exit 1
    }
    # The Windows (MSYS) Git is not compatible with normal use on cygwin
    if [ "$OSTYPE" = cygwin ]; then
      if git --version | grep msysgit > /dev/null; then
        echo "Error: Windows/MSYS Git is not supported on Cygwin"
        echo "Error: Make sure the Cygwin git package is installed and is first on the path"
        exit 1
      fi
    fi
    env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
      printf "Error: git clone of oh-my-zsh repo failed\n"
      exit 1
    }


    printf "${BLUE}Looking for an existing zsh config...${NORMAL}\n"
    if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
      printf "${YELLOW}Found ~/.zshrc.${NORMAL} ${GREEN}Backing up to ~/.zshrc.pre-oh-my-zsh${NORMAL}\n";
      mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
    fi

    printf "${BLUE}Using the Oh My Zsh template file and adding it to ~/.zshrc${NORMAL}\n"
    cp "$ZSH"/templates/zshrc.zsh-template ~/.zshrc
    sed "/^export ZSH=/ c\\
    export ZSH=\"$ZSH\"
    " ~/.zshrc > ~/.zshrc-omztemp
    mv -f ~/.zshrc-omztemp ~/.zshrc

    # If this user's login shell is not already "zsh", attempt to switch.
    TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
    if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
      # If this platform provides a "chsh" command (not Cygwin), do it, man!
      if hash chsh >/dev/null 2>&1; then
        printf "${BLUE}Time to change your default shell to zsh!${NORMAL}\n"
        chsh -s $(grep /zsh$ /etc/shells | tail -1)
      # Else, suggest the user do so manually.
      else
        printf "I can't change your shell automatically because this system does not have chsh.\n"
        printf "${BLUE}Please manually change your default shell to zsh!${NORMAL}\n"
      fi
    fi

    printf "${GREEN}"
    echo '         __                                     __   '
    echo '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
    echo ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
    echo '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
    echo '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
    echo '                        /____/                       ....is now installed!'
    echo ''
    echo ''
    echo 'Please look over the ~/.zshrc file to select plugins, themes, and options.'
    echo ''
    echo 'p.s. Follow us at https://twitter.com/ohmyzsh.'
    echo ''
    echo 'p.p.s. Get stickers and t-shirts at https://shop.planetargon.com.'
    echo ''
    printf "${NORMAL}"
  else
    printf "${YELLOW}You already have Oh My Zsh installed.${NORMAL}\n"
  fi

  ### End of oh-my-zsh setup
  ### Begin .dotfiles install

  DOTFILES_REPO_PATH="$HOME/.dotfiles"
  if [ ! -d "$DOTFILES_REPO_PATH" ]; then
    env git clone --depth=1 https://github.com/morganwallace/.dotfiles "$DOTFILES_REPO_PATH" || {
      printf "Error: git clone of morgan's dotfiles repo failed\n"

    }
  else
    printf "${YELLOW}The path $DOTFILES_REPO_PATH already exits. '.dotfiles' was not cloned.${NORMAL}\n"
  fi

  # Install zsh plugins
  DOTFILES_PLUGIN_PATH="$DOTFILES_REPO_PATH/custom/plugins"
  if [ ! -d "$DOTFILES_PLUGIN_PATH" ]; then
    mkdir "$DOTFILES_PLUGIN_PATH"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$DOTFILES_PLUGIN_PATH/zsh-syntax-highlighting"
  else
    printf "${YELLOW}Syntax highlighting plugin already installed.${NORMAL}\n"
  fi

  # Replace the basic omz zshrc template with ours
  cp $DOTFILES_REPO_PATH/custom/templates/zshrc.zsh-template ~/.zshrc

  # Symlink my global gitignore file
  ln -sf "$DOTFILES_REPO_PATH/.gitignore-global" ~/.gitignore-global

  # Symlink vscode user settings file
  if [ "$(uname)" == "Darwin" ]; then
    ln -sf "$DOTFILES_REPO_PATH/.vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  elif [ "$(uname)" == "Linux" ]; then 
    ln -sf "$DOTFILES_REPO_PATH/.vscode/settings.json" "$HOME/.config/Code/User/settings.json"
  else
    printf "Why are you not using MacOS or Linux?  :(\n"
  fi

  printf "${BLUE}\n"
  echo '       __      __  ____             '
  echo '  ____/ /___  / /_/ __(_) /__  _____'
  echo ' / __  / __ \/ __/ /_/ / / _ \/ ___/'
  echo '/ /_/ / /_/ / /_/ __/ / /  __(__  ) '
  echo '\__,_/\____/\__/_/ /_/_/\___/____/  '
  
  printf "${NORMAL}"
  printf "${BLUE}.dotfiles installed${NORMAL}\n"
  
  
  env zsh -l

}

main
