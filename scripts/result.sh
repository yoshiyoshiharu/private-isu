#!/bin/sh
HOME=/home/isucon
APP_HOME=${HOME}/webapp

MYSQL_SLOW_LOG="/var/log/mysql/slow.log"
NGINX_ACCESS_LOG="/var/log/nginx/access.log"
NGINX_ACCESS_LOG_FORMAT="${APP_HOME}/measure/nginx/access.log"

ALPSORT=sum
# パスパターンを配列として定義
ALP_PATTERNS=(
    "/api/user/.+/icon"
    "/api/user/.+/theme"
    "/api/user/.+/statistics"
    "/api/livestream/.+/statistics"
    "/api/livestream/\\d+/livecomment"
    "/api/livestream/\\d+/moderate"
    "/api/livestream/\\d+/ngwords"
    "/api/livestream/\\d+/exit"
    "/api/livestream/\\d+/enter"
    "/api/livestream/\\d+/livecomment/\\d+/report"
    "/api/livestream/\\d+/report"
    "/api/livestream/\\d+/reaction"
    "/api/livestream/search\?tag=.*"
)

# 配列をカンマ区切りで連結してALPMに代入
ALPM=$(IFS=,; echo "${ALP_PATTERNS[*]}")
OUTFORMAT=count,method,uri,min,max,sum,avg,p99


# alp
sudo alp ltsv --file=${NGINX_ACCESS_LOG} --nosave-pos --pos /tmp/alp.pos --sort ${ALPSORT} --reverse -o ${OUTFORMAT} -q -m ${ALPM} > ${NGINX_ACCESS_LOG_FORMAT}
echo "Nginxのログフォーマット完了"


# ruby
stackprof --d3-flamegraph ${APP_HOME}/measure/ruby/stackprof.dump > ${APP_HOME}/measure/ruby/flamegraph.html
echo "stackprofのhtmlへの変換完了"

# mysql
ssh 57.180.240.214 sudo mysqldumpslow -s t /var/log/mysql/mysql-slow.log > ${APP_HOME}/measure/mysql/mysql-slow.log
echo "Mysqlのスロークエリ出力完了"

