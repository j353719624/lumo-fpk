# LUMO · fnOS 应用包

飞牛 fnOS（NAS 系统）上的 **LUMO 内网穿透客户端**安装包工程。装完在飞牛桌面点「LUMO」即可用。

> LUMO（隧光）—— 一条隧道，两端点亮。把 NAS、路由器、远程桌面、公司电脑接进同一张网，
> 在外访问和在局域网里没有区别。

## 这是什么

这是一份**纯客户端**应用包：把本机服务通过 LUMO 隧道送到公网，服务端另行部署在有公网 IP 的机器上。

- 不占公网端口：密钥隧道与打洞直连都凭密钥接入，公网上没有入口
- 四种接入：端口映射（TCP / UDP）、HTTP / HTTPS 反代、密钥隧道、打洞直连
- 协议自研：长度分帧 JSON + Ed25519 签名认证，服务端磁盘只存公钥
- 装完即用：向导里填好服务端信息，连接会自动出现在控制台
- 一直在线：随开机自启，进程异常退出自动拉起

## 安装

1. 从 [Releases](../../releases) 下载 `lumo-<版本>-x86.fpk`
2. 飞牛应用中心 → 手动安装 → 从 NAS 添加（或上传）
3. 向导填写：
   - 服务端地址、服务端端口、KCP 端口（填 0 只用 TCP）
   - 隧道密钥（由服务端提供）
   - 控制台登录账号与密码
4. 装完从桌面点「LUMO」，用上面设的账号密码登录

控制台同时监听 unix socket（供飞牛桌面网关）与 TCP `7505`（局域网直连）。

## 构建

需要 Go 1.26+ 与 `fnpack`（飞牛系统自带，或见 [fnOS 开发者文档](https://developer.fnnas.com/)）。

```bash
# 编译 linux/amd64 客户端并打包
LUMOC_BIN=../lumo-clean/bin/lumoc-linux ./build.sh
# 产出：lumo.fpk
```

`LUMOC_BIN` 可省略（会调用本机 `go build`），也可指向任意预编译好的 linux/amd64 `lumoc`。

## 目录结构

```text
├── manifest             # 应用元数据（appname / version / 描述 / 入口）
├── cmd/                 # 生命周期脚本
│   ├── main             #   启动、停止、状态、watchdog 守护
│   ├── install_init     #   安装前（停旧实例）
│   ├── install_callback #   安装后（写控制台凭据、按向导值生成连接）
│   ├── config_init      #   设置页读取
│   ├── config_callback  #   设置页保存
│   ├── uninstall_*      #   卸载前后（收进程，可选清数据）
│   └── upgrade_*        #   升级前后
├── config/              # 权限声明与数据共享
├── wizard/              # 安装 / 卸载向导表单
├── app/
│   ├── bin/lumoc        # 构建产物，不入库
│   └── ui/              # 桌面入口（gatewaySocket）与图标
├── ICON.PNG / ICON_256.PNG
└── build.sh
```

## 运行时约定

| 项目 | 位置 |
|---|---|
| 连接配置 | `<应用数据>/lumo-configs.json` |
| 控制台凭据 | `<应用数据>/console.env` |
| 运行日志 | `<应用数据>/info.log`、`lumoc.log`、`watchdog.log` |
| 桌面入口 socket | `<应用安装目录>/app.sock` |

进程分两层：`lumoc ui` 主进程负责控制台与连接管理，每条连接一个 `lumoc engine` 子进程。
主进程以 `setsid` 自成进程组，停止时整组回收；卸载时再按路径扫一遍兜底，不留孤儿。

## 注意

飞牛的 `password` 类型向导字段**不会**作为环境变量传给安装脚本，因此需要参与配置的字段一律用 `text` 类型。

## 协议

应用元数据为 fnOS 约定的 TOML（`manifest`）；生命周期脚本为 bash，须可执行。
打包使用 `fnpack build`，不要手工打 tar。
