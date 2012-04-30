#!/bin/bash

#pull repos
pushd ~/home_dir
echo "Getting latest environment"
git pull
popd

# delete symbolic links
rm ~/.vimrc
rm ~/.screenrc
rm ~/.bashrc
rm ~/.alias

# create symbolic links to .dotfiles
ln -s ~/home_dir/.dotfiles/vimrcfile ~/.vimrc
ln -s ~/home_dir/.dotfiles/screenrcfile ~/.screenrc
ln -s ~/home_dir/.dotfiles/bashrcfile ~/.bashrc
ln -s ~/home_dir/.dotfiles/aliasfile ~/.alias
