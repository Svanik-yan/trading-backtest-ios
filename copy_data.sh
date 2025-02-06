#!/bin/bash

# 创建目标目录
mkdir -p TradingBacktestApp/public/daily_stock_data

# 复制数据文件
cp public/stock_list.txt TradingBacktestApp/public/
cp public/daily_stock_data/*.txt TradingBacktestApp/public/daily_stock_data/ 