#!/bin/bash

set -e

USERS=("yoshiyoshiharu" "KoyamaShimpei" "taiwork")
REPOSITORY_NAME="git@github.com:yoshiyoshiharu/isucon14-qualify.git"

# authorized_keysにgithubに登録しているssh公開鍵を登録する
for user in ${USERS[@]}; do
  echo $(curl -fs "https://github.com/${user}.keys") >> ~/.ssh/authorized_keys
done
echo "authorized_keysにGithubのSSH公開鍵を登録しました"

git config --global core.editor "vim"
git config --global user.email "haruki.osaka.u@gmail.com"
git config --global user.name "yoshiyoshiharu"
