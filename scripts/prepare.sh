#!/bin/sh
set -ex

# 環境変数
GIT_REPOSITORY_DIR="$HOME"

MYSQL_SLOW_LOG="/var/log/mysql/mysql-slow.log"
NGINX_ACCESS_LOG="/var/log/nginx/access.log"
APP_PROF="$HOME/webapp/measure/ruby/stackprof.dump"
SYSTEMCTL_APP="isuports.service"

# 最新状態にする
git pull

# ホームディレクトリのgit管理用のetcディレクトリにある設定ファイルをetcディレクトリにコピー
cp -r ${GIT_REPOSITORY_DIR}/etc/nginx/* /etc/nginx
cp -r ${GIT_REPOSITORY_DIR}/etc/mysql/* /etc/mysql

# ログをクリア
sudo truncate -s 0 "${MYSQL_SLOW_LOG}"
sudo truncate -s 0 "${NGINX_ACCESS_LOG}"
sudo truncate -s 0 "${APP_PROF}"

# サービスの再起動
sudo systemctl restart nginx
sudo systemctl restart mysql
sudo systemctl daemon-reload
sudo systemctl restart isuports.service

echo "MySQLとNginxのログクリアおよびサービスの再起動が完了しました"
