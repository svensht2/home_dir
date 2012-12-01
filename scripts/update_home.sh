#!/bin/bash
HOMEDIR=home_dir
#pull repos
pushd ~/${HOMEDIR}
echo "Getting latest environment..."
git pull
echo "Getting latest submodules..."
git submodule foreach git pull
popd

# delete symbolic links
rm -rf ~/.vim
rm -rf ~/scripts
rm ~/.vimrc
rm ~/.screenrc
rm ~/.bashrc
rm ~/.alias

# create symbolic links to .dotfiles
ln -s ~/${HOMEDIR}/.vim ~/.vim
ln -s ~/${HOMEDIR}/scripts ~/scripts
ln -s ~/${HOMEDIR}/.dotfiles/vimrcfile ~/.vimrc
ln -s ~/${HOMEDIR}/.dotfiles/screenrcfile ~/.screenrc
ln -s ~/home_dir/.dotfiles/bashrcfile ~/.bashrc
ln -s ~/home_dir/.dotfiles/aliasfile ~/.alias
