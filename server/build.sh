#!/bin/bash
# 构建 fnOS FPK 安装包（服务端）。产出：lumo-server.fpk
#
# 前置条件（二选一）：
#   - 在 fnOS 本机运行：fnpack 已内置，只需 Go 1.26+（或直接跳过编译，见 ENV）
#   - 在其他 linux/amd64 机器：需要 Go 1.26+ 与 fnpack（https://developer.fnnas.com/）
#
# 环境变量：
#   LUMOS_BIN   预编译好的 linux/amd64 lumos 路径；设置后跳过本地编译
#   LUMOC_BIN   预编译好的 linux/amd64 lumoc 路径（安装时生成服务端配置）
#   LUMO_SRC    Go 源码目录（主仓 lumo），默认 ../lumo
set -e
cd "$(dirname "$0")"

# 本仓库只含打包源；Go 源码在主仓 lumo，克隆到同级目录即可直接编译：
#   git clone https://github.com/j353719624/lumo ../lumo
LUMO_SRC="${LUMO_SRC:-../lumo}"

if [ -n "${LUMOS_BIN}" ]; then
    cp "${LUMOS_BIN}" app/bin/lumos
else
    # go build 的包路径必须在模块内：先进源码目录再编译，输出回当前目录
    (cd "${LUMO_SRC}" && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
        go build -trimpath -ldflags "-s -w" -o "$OLDPWD/app/bin/lumos" ./cmd/lumos)
fi
if [ -n "${LUMOC_BIN}" ]; then
    cp "${LUMOC_BIN}" app/bin/lumoc
else
    (cd "${LUMO_SRC}" && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
        go build -trimpath -ldflags "-s -w" -o "$OLDPWD/app/bin/lumoc" ./cmd/lumoc)
fi
chmod 755 app/bin/lumos app/bin/lumoc

chmod +x cmd/*
command -v fnpack >/dev/null 2>&1 || { echo "fnpack 不存在，请先在 fnOS 上运行或安装 fnpack" >&2; exit 1; }
fnpack build --directory .

echo "产出：$(pwd)/lumo-server.fpk"
