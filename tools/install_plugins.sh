# update the vimrc file with the template
printf "${BLUE}Looking for an existing vim config...${NORMAL}\n"
if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
    printf "${YELLOW}Found ~/.vimrc.${NORMAL} ${GREEN}Backing up to ~/.vimrc.pre-oh-my-zsh${NORMAL}\n";
    mv ~/.vimrc ~/.vimrc.pre-oh-my-zsh;
fi
cp $ZSH/templates/.vimrc ~/

cd ~/.dotfiles/custom/plugins;
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/olivierverdier/zsh-git-prompt.git
git clone https://github.com/zpm-zsh/autoenv
