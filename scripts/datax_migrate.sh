#!/bin/bash

# 配置DataX安装路径
DATAX_HOME=/path/to/datax

# 源数据库配置
SRC_HOST="source_host"
SRC_PORT="source_port"
SRC_USER="source_user"
SRC_PASSWORD="source_password"
SRC_DB="source_database"
SRC_TABLE="source_table"

# 目标数据库配置
DEST_HOST="destination_host"
DEST_PORT="destination_port"
DEST_USER="destination_user"
DEST_PASSWORD="destination_password"
DEST_DB="destination_database"
DEST_TABLE="destination_table"

# 创建DataX JSON配置文件
CONFIG_FILE="datax_config.json"

cat > $CONFIG_FILE <<EOL
{
  "job": {
    "setting": {
      "speed": {
        "channel": 1
      }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "$SRC_USER",
            "password": "$SRC_PASSWORD",
            "column": ["*"],
            "splitPk": "id",
            "connection": [
              {
                "table": ["$SRC_TABLE"],
                "jdbcUrl": ["jdbc:mysql://$SRC_HOST:$SRC_PORT/$SRC_DB"]
              }
            ]
          }
        },
        "writer": {
          "name": "mysqlwriter",
          "parameter": {
            "username": "$DEST_USER",
            "password": "$DEST_PASSWORD",
            "column": ["*"],
            "preSql": [],
            "postSql": [],
            "connection": [
              {
                "table": ["$DEST_TABLE"],
                "jdbcUrl": ["jdbc:mysql://$DEST_HOST:$DEST_PORT/$DEST_DB"]
              }
            ]
          }
        }
      }
    ]
  }
}
EOL

# 执行DataX数据迁移
$DATAX_HOME/bin/datax.py $CONFIG_FILE

# 清理配置文件
rm -f $CONFIG_FILE

echo "Data migration completed successfully."
