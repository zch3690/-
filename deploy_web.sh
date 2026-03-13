#!/bin/bash
set -e

# 1. 备份
BACKUP_DIR="/backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r /usr/share/nginx/html/* $BACKUP_DIR/

# 2. 拉最新代码
cd /usr/share/nginx/html
git pull origin main

# 3. 重启 Nginx
systemctl restart nginx

# 4. 检查是否启动成功
if curl -I http://localhost | grep "200 OK"; then
  echo "部署成功"
else
  echo "部署失败，开始回滚"
  cp -r $BACKUP_DIR/* /usr/share/nginx/html/
  systemctl restart nginx
  exit 1
fi
