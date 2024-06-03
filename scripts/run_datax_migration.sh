#!/bin/bash

# 假设 DataX 安装在 /opt/datax 目录
DATAX_HOME=/opt/datax

# DataX JSON 配置文件路径（需要根据你的实际配置进行调整）
DATAX_JOB_CONFIG=/path/to/datax/job/config.json

# 切换到 DataX 目录并执行迁移任务
cd $DATAX_HOME
python bin/datax.py $DATAX_JOB_CONFIG
