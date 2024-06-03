#!/bin/bash

# MySQL 连接信息
DB1_HOST="your_db1_host"
DB1_USER="your_db1_user"
DB1_PASS="your_db1_password"
DB1_NAME="your_db1_name"

DB2_HOST="your_db2_host"
DB2_USER="your_db2_user"
DB2_PASS="your_db2_password"
DB2_NAME="your_db2_name"

# 表名
TABLE_NAME="your_table_name"

# 查询数据库1中的行数
DB1_COUNT=$(mysql -h $DB1_HOST -u $DB1_USER -p$DB1_PASS -D $DB1_NAME -e "SELECT COUNT(*) FROM $TABLE_NAME;" | tail -n 1)

# 查询数据库2中的行数
DB2_COUNT=$(mysql -h $DB2_HOST -u $DB2_USER -p$DB2_PASS -D $DB2_NAME -e "SELECT COUNT(*) FROM $TABLE_NAME;" | tail -n 1)

# 比较数据量
if [ "$DB1_COUNT" -eq "$DB2_COUNT" ]; then
    echo "Data count is equal: $DB1_COUNT"
    exit 0
else
    echo "Data count is not equal. DB1: $DB1_COUNT, DB2: $DB2_COUNT"
    exit 1
fi
