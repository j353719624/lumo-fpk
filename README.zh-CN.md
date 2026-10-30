# LUMO 隧光 · 飞牛应用包

[English](README.md) | **简体中文**

[LUMO](https://github.com/j353719624/lumo) 内网穿透的 [飞牛 fnOS](https://www.fnnas.com/) 应用包，
一套项目两个包，按机器所在的位置选：

| 目录 | 应用包 | 装在哪 | 干什么 |
|---|---|---|---|
| [`client/`](client) | LUMO 客户端 | NAT **后面的** NAS / 电脑 | 把本机服务通过隧道送出去 |
| [`server/`](server) | LUMO 服务端 | **有公网 IP 的**机器 | 接住客户端的隧道，占公网端口 |

每个目录都是完整独立的 fnpack 打包源（manifest、生命周期脚本、安装向导、桌面入口）。成品
`.fpk` 去 [Releases](../../releases) 下载 —— 标签名标明了属于哪个包
（`v0.1.0` = 客户端，`server-v0.1.0` = 服务端）。

## 安装

飞牛应用中心 → 手动安装 → 上传 `.fpk`，按向导填：

- **客户端**：服务端地址、端口、KCP 端口、隧道密钥、控制台账号密码 —— 连接由向导直接生成，
  装完即用
- **服务端**：服务端口、KCP 端口、HTTP 端口、控制台账号密码 —— 隧道密钥安装时自动生成，在
  应用数据目录的 `tunnel-secret.txt` 里

## 从源码构建

两个包构建方式一致；进 `client/` 或 `server/` 执行：

```bash
# Go 源码在主仓 lumo，克隆到同级目录即可：
#   git clone https://github.com/j353719624/lumo ../lumo
./build.sh                      # 脚本自己编译 linux/amd64 二进制
# 或者直接指向预编译好的二进制，跳过编译：
LUMOS_BIN=/path/to/lumos LUMOC_BIN=/path/to/lumoc LUMO_SRC=/path/to/lumo ./build.sh
# 产物：<client|server>.fpk
```

需要 Go 1.26+ 与 `fnpack`（飞牛内置）。向导字段、运行时布局、脚本细节见各自目录的 README。

## 坑（两个包都有）

飞牛**不会**把 `password` 类型的向导字段作为环境变量传给安装脚本，所以脚本要读的字段必须声明成
`text`。

## 许可

**PolyForm Noncommercial License 1.0.0** —— 可自由使用、修改与分发，**商用需作者授权**。
允许范围见 [LICENSING.md](LICENSING.md)，完整条款见 [LICENSE](LICENSE)。
