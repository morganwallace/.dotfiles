# Custom aliases and functions

# Code Editor
alias edit="code"
alias codeupdate="sudo apt-get install code"
alias sublupdate="sudo apt-get install subl"

# Git Aliases
alias gits="git status"
alias gitundo="git reset --soft HEAD~"
alias delbranch="git branch -D"
alias cleanbranches="git checkout develop && git pull origin develop && git branch --merged | grep -Ev 'develop|core|\*' | xargs git branch -d && git remote prune origin"
alias gitgraph="git log --graph --pretty=oneline --abbrev-commit"
alias mylog="git log --author=Morgan"
alias mygraph="git log --graph --pretty=oneline --abbrev-commit --author=Morgan"
alias difflast="git diff HEAD~1"
alias jiracommit="git commit --allow-empty -m"

alias svba="source venv/bin/activate"

# Locations
export DOTFILESHOME=$HOME/.dotfiles
export DEVHOME=$HOME/Developer

alias dev="cd $DEVHOME && ls"

# Zsh aliases
alias settings="edit $HOME/.zshrc"
alias dotfiles="cd $DOTFILESHOME"
alias shortcuts="edit $DOTFILESHOME/custom/aliases.zsh"
alias mytheme="edit $DOTFILESHOME/themes/morgan.zsh-theme"

# System Aliases
alias settime="sudo ntpdate -u pool.ntp.org"
alias lookat="watch -n1 -- "
alias search='find . -name'
alias killchromes='killall -i chrome'
alias rmpyc="find . -name '*.pyc' -exec rm -rf {} \;"
alias virt="source ${VENV_BIN}activate"
alias act="virt"
alias rebuildnode="sudo apt-get --purge -f remove node && sudo apt-get --purge -f remove nodejs && sudo apt-get -f install nodejs"

# NOTE must install xclip: `sudo apt-get install xclip`
alias copy="xclip -selection c"
alias pwdc="pwd | copy"

# Custom searcher
mg () { grep -Rn "$*" *; }

# Git custom functions
function pr() {
    git fetch -fu origin pull/$1/head:pr/$1
    git checkout pr/$1

    # Check to see if the git checkout was successful
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$BRANCH" == "pr/$1" ]]; then
        git pull -f origin pull/$1/head:pr/$1
        checkmigrations
    else
        echo 'Was not able to change branch';
    fi
}

function getbranch() {
    git fetch -fu origin $1:$1
    git checkout $1
}

# Node & NPM functions
function vnpm() {
    sudo rm `which npm`
    sudo ln -s /usr/local/n/versions/node/$1/lib/node_modules/npm/cli.js /usr/local/bin/npm
}

# Change node and npm versions before node v4
function chnode() {
    sudo n $1
    sudo vnpm $1
}
