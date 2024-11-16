#!/bin/bash

set -e

# ローカルで修正してからscpする
# scp -r ./scripts  isucon@3.113.6.158:~/private_isu/webapp/
REPOSITORY_NAME="git@github.com:yoshiyoshiharu/isucon14.git"
GIT_REPOSITORY_DIR="$HOME/private-isu/webapp"

if [ ! -e ~/.ssh/github_deploy_key ]; then
  echo "デプロイキーを生成します"
  ssh-keygen -t rsa -f ~/.ssh/github_deploy_key
  echo "デプロイキーの公開鍵は以下です"
  cat ~/.ssh/github_deploy_key.pub
fi

echo "Githubに公開鍵を登録しましたか？(y/n)"
read ANSWER
if [ $ANSWER != "y" ]; then
  echo "Githubに公開鍵を登録してください"
  exit 1
fi

cat <<EOF > ~/.ssh/config
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_deploy_key
EOF
echo "GithubのSSH設定を追加しました"

# Gitの設定
cat <<EOF > ~/.gitconfig
[user]
  email = haruki.osaka.u@gmail.com
  name = yoshiyoshiharu
[core]
  editor = vim
[alias]
  st = status
  l = log --oneline --graph --decorate
  cm = commit
  co = checkout
  sw = switch
  br = branch
  ps = push
  pl = pull
EOF
echo ".gitconfigの設定を追加しました"

cd $GIT_REPOSITORY_DIR
if [ ! -d .git ]; then
  git init
  git remote add origin REPOSITORY_NAME
  echo "git initとリモートリポジトリを設定しました"
fi

# Vimの設定
cat <<EOF > ~/.vimrc
filetype plugin indent on
"""
""" common
"""
let mapleader = " "

set autoindent
set background=dark
set clipboard=unnamed
set encoding=utf-8
set expandtab
set hlsearch
set noswapfile
set number
set shiftwidth=2
set tabstop=2
set iskeyword+=\-
set nowrap
set ignorecase
set smartcase
set wildmenu
set showcmd
set smarttab
set laststatus=2
set incsearch
set ruler
set cursorline
set mouse=a
syntax on

"""
""" change cursor by mode
"""
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

"""
""" set per extensions
"""
autocmd Filetype java   setlocal ts=4 sw=4 cc=100
autocmd Filetype php    setlocal ts=4 sw=4
autocmd Filetype python setlocal ts=2 sw=2
autocmd Filetype ruby   setlocal ts=2 sw=2 cc=100
autocmd Filetype xml    setlocal ts=2 sw=2 
autocmd Filetype html   setlocal ts=2 sw=2 cc=100
autocmd Filetype sh     setlocal ts=2 sw=2 cc=100
autocmd Filetype sql    setlocal ts=2 sw=2 
autocmd BufNewFile,BufRead *.less set syntax=css

"""
""" key mapping
"""
inoremap <silent> jj <ESC>
inoremap <silent> jk <ESC>
nnoremap <silent> <leader>h ^
nnoremap <silent> <leader>l $
EOF
echo "vimrcの設定を追加しました"

## bashrcの設定
cat <<EOF > ~/.bashrc
  alias ls='ls -G'
  alias ll='ls -lG'
  alias la='ls -laG'

  alias g='git'
  if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1) \$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1) \$ '
  fi
EOF


# authorized_keysにgithubに登録しているssh公開鍵を登録する
USERS=("yoshiyoshiharu" "KoyamaShimpei" "taiwork")
for user in ${USERS[@]}; do
  curl -fs "https://github.com/${user}.keys" >> ~/.ssh/authorized_keys
done
echo "authorized_keysにGithubのSSH公開鍵を登録しました"

# etc配下のミドルウェアの設定ファイルをホームディレクリにコピー
NGINX_CONF_DIR="/etc/nginx"
MYSQL_CONF_DIR="/etc/mysql"
WHOAMI="isucon"

mkdir -p ${GIT_REPOSITORY_DIR}/etc

cp -r ${NGINX_CONF_DIR} ${GIT_REPOSITORY_DIR}/etc
cp -r ${MYSQL_CONF_DIR} ${GIT_REPOSITORY_DIR}/etc
chown -R ${WHOAMI}:${WHOAMI} ${GIT_REPOSITORY_DIR}/etc
echo "done: ミドルウェアの設定ファイルをホームディレクトリにコピーしました"
