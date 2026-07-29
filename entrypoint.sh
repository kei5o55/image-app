#!/bin/bash
set -e

# 前回終了時の pid ファイルを削除
rm -f /app/tmp/pids/server.pid

# コンテナのメインプロセスを実行
exec "$@"