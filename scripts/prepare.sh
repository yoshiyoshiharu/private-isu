#!/bin/sh
set -ex

# [TODO: 最初に設定] 環境変数
GIT_REPOSITORY_DIR="$HOME/private_isu/webapp"
SYSTEMCTL_APP="isu-ruby"
MYSQL_SLOW_LOG="/var/log/mysql/mysql-slow.log"
NGINX_ACCESS_LOG="/var/log/nginx/access.log"
APP_PROF="$GIT_REPOSITORY_DIR/ruby/tmp"

# 最新状態にする
git pull

# ホームディレクトリのgit管理用のetcディレクトリにある設定ファイルをetcディレクトリにコピー
cp -r ${GIT_REPOSITORY_DIR}/etc/nginx/* /etc/nginx
cp -r ${GIT_REPOSITORY_DIR}/etc/mysql/* /etc/mysql

# ログをクリア
sudo truncate -s 0 "${MYSQL_SLOW_LOG}"
sudo truncate -s 0 "${NGINX_ACCESS_LOG}"
if [ -d $APP_HOME ]; then
  rm -r ${APP_PROF}
fi

# サービスの再起動 最初に設定する
sudo systemctl restart nginx
sudo systemctl restart mysql

# [TODO: 最初に設定] アプリケーションの再起動
sudo systemctl restart ${SYSTEMCTL_APP}

echo "MySQLとNginxのログクリアおよびサービスの再起動が完了しました"
