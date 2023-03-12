#!/usr/bin/env bash

if bin/confirm -p "Reload shell?" -d y; then
	source etc/.bashrc
fi

if bin/confirm -p "Install vim plug?"; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	vim +PlugInstall +qa!
fi
