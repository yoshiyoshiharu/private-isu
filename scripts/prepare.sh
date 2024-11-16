#!/bin/sh
set -ex

# 環境変数
GIT_REPOSITORY_DIR="$HOME/private-isu/webapp"
SYSTEMCTL_APP="isuports.service"

MYSQL_SLOW_LOG="/var/log/mysql/mysql-slow.log"
NGINX_ACCESS_LOG="/var/log/nginx/access.log"
APP_PROF="$GIT_REPOSITORY_DIR/measure/ruby/stackprof.dump"

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
sudo systemctl restart ${SYSTEMCTL_APP}

echo "MySQLとNginxのログクリアおよびサービスの再起動が完了しました"
