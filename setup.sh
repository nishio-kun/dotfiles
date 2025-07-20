ln -is `pwd`/zsh/.zshrc ~/.zshrc
ln -ins `pwd`/zsh/.zfunc ~/.zfunc
ln -is `pwd`/vim/.vimrc ~/.vimrc
ln -ins `pwd`/vim/.vim ~/.vim
ln -ins `pwd`/editors/.lem ~/.lem
ln -is `pwd`/tmux/.tmux.conf ~/.tmux.conf

mkdir -p ~/.zsh/completion/

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.zsh/completion/git-completion.zsh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.zsh/completion/git-prompt.sh

chmod a+x ~/.zsh/completion/git-prompt.sh
chmod a+x ~/.zsh/completion/git-completion.zsh

mv ~/.zsh/completion/git-completion.zsh ~/.zsh/completion/_git

rm -f ~/.zcompdump

# Download iTerm2 color schemes
mkdir -p iterm2
curl -o iterm2/GitHub-Dark.itermcolors "https://raw.githubusercontent.com/alDuncanson/Github-Dark/main/GitHub%20Dark.itermcolors"
