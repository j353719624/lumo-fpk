# LUMO · fnOS packages

**English** | [简体中文](README.zh-CN.md)

Installable [fnOS](https://www.fnnas.com/) (飞牛 NAS) application packages for the
[LUMO](https://github.com/j353719624/lumo) tunnel. Two packages, one per role — pick by where the
machine sits:

| Directory | Package | Install on | What it does |
|---|---|---|---|
| [`client/`](client) | LUMO 客户端 | NAS / PC **behind NAT** | Publishes local services out through the tunnel |
| [`server/`](server) | LUMO 服务端 | Machine **with a public IP** | Catches tunnels from clients, owns the public ports |

Each directory is a complete, self-contained fnpack source tree (manifest, lifecycle scripts,
install wizard, desktop entry). Download ready-made `.fpk` files from
[Releases](../../releases) — the tag name says which package it belongs to
(`v0.1.0` = client, `server-v0.1.0` = server).

## Install

fnOS App Center → Manual install → upload the `.fpk`, then fill in the wizard:

- **client**: server address, server port, KCP port, tunnel secret, console account/password —
  the connection is created from the wizard, works right after install
- **server**: service port, KCP port, HTTP port, console account/password — the tunnel secret is
  generated at install time and waits in the app data folder as `tunnel-secret.txt`

## Build from source

Each package builds the same way; run inside `client/` or `server/`:

```bash
# the Go sources live in the main repo, cloned next to this one:
#   git clone https://github.com/j353719624/lumo ../lumo
./build.sh                      # builds linux/amd64 binaries itself
# or point at prebuilt binaries and skip compiling:
LUMOS_BIN=/path/to/lumos LUMOC_BIN=/path/to/lumoc LUMO_SRC=/path/to/lumo ./build.sh
# output: <client|server>.fpk
```

Requires Go 1.26+ and `fnpack` (built into fnOS). See each package's README for the full
wizards, runtime layout and scripts.

## Gotcha (both packages)

fnOS does **not** pass `password` wizard fields to install scripts as environment variables, so any
field a script reads must be declared as `text`.

## License

**PolyForm Noncommercial License 1.0.0** — free to use, modify and share, **commercial use requires the
author's permission**. See [LICENSING.md](LICENSING.md); the full text is in [LICENSE](LICENSE).
