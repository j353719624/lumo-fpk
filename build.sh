#!/bin/bash
# 构建 fnOS FPK 安装包。产出：fpk/lumo.fpk
#
# 前置条件（二选一）：
#   - 在 fnOS 本机运行：fnpack 已内置，只需 Go 1.26+（或直接跳过编译，见 ENV）
#   - 在其他 linux/amd64 机器：需要 Go 1.26+ 与 fnpack（https://developer.fnnas.com/）
#
# 环境变量：
#   LUMOC_BIN   预编译好的 linux/amd64 lumoc 路径；设置后跳过本地编译
#               （例如交叉编译机上传的二进制）
set -e
cd "$(dirname "$0")"

if [ -n "${LUMOC_BIN}" ]; then
    cp "${LUMOC_BIN}" app/bin/lumoc
else
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
        go build -trimpath -ldflags "-s -w" -o app/bin/lumoc ../../cmd/lumoc
fi
chmod 755 app/bin/lumoc

chmod +x cmd/*
command -v fnpack >/dev/null 2>&1 || { echo "fnpack 不存在，请先在 fnOS 上运行或安装 fnpack" >&2; exit 1; }
fnpack build --directory .

echo "产出：$(pwd)/lumo.fpk"
