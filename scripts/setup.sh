#!/bin/bash

set -e

REPOSITORY_NAME="git@github.com:yoshiyoshiharu/isucon14-qualify.git"
GIT_REPOSITORY_DIR="$HOME/private-isu/webapp"

# authorized_keysにgithubに登録しているssh公開鍵を登録する
USERS=("yoshiyoshiharu" "KoyamaShimpei" "taiwork")
for user in ${USERS[@]}; do
  curl -fs "https://github.com/${user}.keys" >> ~/.ssh/authorized_keys
done
echo "authorized_keysにGithubのSSH公開鍵を登録しました"

git config --global core.editor "vim"
git config --global user.email "haruki.osaka.u@gmail.com"
git config --global user.name "yoshiyoshiharu"

# etc配下のミドルウェアの設定ファイルをホームディレクリにコピー
NGINX_CONF_DIR="/etc/nginx"
MYSQL_CONF_DIR="/etc/mysql"
WHOAMI="isucon" 

mkdir -p ${GIT_REPOSITORY_DIR}/etc

cp -r ${NGINX_CONF_DIR} ${GIT_REPOSITORY_DIR}/etc
cp -r ${MYSQL_CONF_DIR} ${GIT_REPOSITORY_DIR}/etc
chown -R ${WHOAMI}:${WHOAMI} ${GIT_REPOSITORY_DIR}/etc
echo "done: ミドルウェアの設定ファイルをホームディレクトリにコピーしました"
