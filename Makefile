.PHONY: all clean

all:
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux ] || ln -s $(PWD)/tmux ~/.tmux
	[ -f ~/.ycm_extra_conf.py ] || ln -s $(PWD)/ycm_extra_conf.py ~/.ycm_extra_conf.py

clean:
	[ -f ~/.vimrc ] || rm ~/.vimrc
	[ -f ~/.zshrc ] || rm ~/.zshrc
	[ -f ~/.tmux ] || rm ~/.tmux
	[ -f ~/.ycm_extra_conf.py ] || rm ~/.ycm_extra_conf.py
