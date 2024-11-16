#!/bin/sh
set -ex

# 環境変数
mysql_slow_log="/var/log/mysql/mysql-slow.log"
nginx_access_log="/var/log/nginx/access.log"
app_prof="$HOME/webapp/measure/ruby/stackprof.dump"
systemctl_app="isuports.service"

# 最新状態にする
git pull

# ログをクリア
sudo truncate -s 0 "${mysql_slow_log}"
sudo truncate -s 0 "${nginx_access_log}"
sudo truncate -s 0 "${app_prof}"

# サービスの再起動
sudo systemctl restart nginx
sudo systemctl restart mysql
sudo systemctl daemon-reload
sudo systemctl restart isuports.service

echo "MySQLとNginxのログクリアおよびサービスの再起動が完了しました"
