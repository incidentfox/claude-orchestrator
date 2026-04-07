# CallClaude

**[:gb: English](#install)** | **[:cn: 简体中文](#zh-简体中文)**

> Call your local Claude Code sessions. Literally, from a phone call.

![Claude Code](https://img.shields.io/badge/Claude_Code-000?style=flat&logo=anthropic&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=node.js&logoColor=white)
![Retell AI](https://img.shields.io/badge/Retell_AI-FF6B35?style=flat&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-000000?style=flat&logo=apple&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)

## Install

Fire up [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and paste:

```
Clone https://github.com/incidentfox/callclaude.git into ~/development/, read the CLAUDE.md, run setup.sh, then walk me through the full setup. I want to manage my Claude Code sessions from my phone by the end of this.
```

Requires macOS, [tmux](https://github.com/tmux/tmux), [ngrok](https://ngrok.com/), Node.js 18+, [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code).

## Demo (real call, ~1 min)

I called the agent over the phone and recorded my Claude Code terminal in the meantime. It relayed commands to the terminal and understood the outputs.

https://github.com/user-attachments/assets/9514e65d-3f81-4f93-9f16-83522bbbf8e3

## Why

I run a bunch of Claude Code sessions on my laptop and lose track of which terminal is doing what. I wanted to check on them from my car — but I drive a Tesla and didn't want to deal with getting an app on the Tesla browser. A phone call bypasses all of that.

This whole thing was built in a single Claude Code session. The voice agent, the bridge server, the CLI, the cross-session messaging — all of it. Claude Code set itself up.

## What you can do

| Command | What it does |
|---------|-------------|
| "What sessions are running?" | Lists all active Claude Code sessions |
| "What's the main session working on?" | Reads recent conversation from a session |
| "Tell the forta session to check the build" | Injects a message into any running session |
| "Start a new session in ~/projects/myapp" | Spins up a new background session |
| "Kill the test session" | Stops a session |

Or use the CLI directly:

```bash
claude-sessions list -a                          # See all active sessions
claude-sessions send myapp "check build" -w      # Send message + wait for response
claude-sessions read myapp -n 20                 # Read last 20 messages
claude-sessions fork myapp -b                    # Fork a session with full context
claude-sessions start demo ~/code -b -p "run tests"  # New session with prompt
```

## How it works

```
Your phone → Retell AI (STT + LLM) → ngrok → bridge server → claude-sessions → Terminal.app → Claude Code
```

You get a phone number via [Retell AI](https://www.retellai.com/) (also works with [Vapi](https://vapi.ai/)). When you call it, Retell does speech-to-text, sends the text to [Claude Sonnet](https://docs.anthropic.com/en/docs/about-claude/models) which decides what tool to call, and hits your bridge server through an [ngrok](https://ngrok.com/) tunnel. The bridge server runs on your Mac and translates tool calls into `claude-sessions` CLI commands — which find the right Terminal.app tab by tty device path, inject keystrokes via AppleScript, and watch the JSONL conversation file with macOS kqueue for the response.

Everything runs locally. Retell only sees tool call names and results.

## Features

- **Voice control** — call a phone number, talk to your sessions hands-free
- **Cross-session messaging** — sessions can talk to each other via AppleScript keystroke injection
- **Session management** — list, start, kill, resume, fork, archive sessions
- **Orchestrator pattern** — one session acts as the hub with Telegram + voice access
- **Telegram integration** — check on sessions from your phone via text
- **Auto-recording** — every call is recorded and transcribed with timestamps
- **Phone allowlist** — only your number can control your machine
- **API secret** — bridge server rejects unauthenticated requests

## Security

- **API secret** — the bridge server rejects all requests without a secret token. Without it, discovering your ngrok URL does nothing.
- **Phone allowlist** — set `ALLOWED_PHONE_NUMBERS` in `.env`. Only your number gets through.
- **`--dangerously-skip-permissions`** — sessions run with permissions disabled so the voice agent can execute without prompts. The phone allowlist is your access control.
- **ngrok** — kill ngrok and nothing is reachable.

## Project structure

```
callclaude/
├── CLAUDE.md                 # Setup instructions for Claude Code
├── setup.sh                  # One-shot installer
├── .env.example              # Config template
├── bin/
│   └── claude-sessions       # Session management CLI (Python)
├── bridge/
│   └── server.js             # HTTP bridge (Express, Retell + Vapi)
└── scripts/
    ├── setup-retell.js       # Create voice agent + phone number
    └── update-retell-url.js  # Fix webhook URLs after ngrok restart
```

## License

MIT — built by [@incidentfox](https://github.com/incidentfox)

---

# :cn: 简体中文

## CallClaude 是什么

用电话控制你本地的 Claude Code 会话。真的，打个电话就行。

你在笔记本上跑着好几个 Claude Code 会话——一个在重构代码，一个在跑测试，一个在做研究。合上笔记本就完全失联了。CallClaude 给你一个电话号码，打过去就能查看所有会话状态、给任意会话发指令、读取会话历史、启动新会话。

为什么是电话？因为我开特斯拉，不想折腾车载浏览器装什么 app。电话在任何车里都能用。

## 安装

打开 [Claude Code](https://docs.anthropic.com/en/docs/claude-code)，粘贴以下内容：

```
Clone https://github.com/incidentfox/callclaude.git into ~/development/, read the CLAUDE.md, run setup.sh, then walk me through the full setup. I want to manage my Claude Code sessions from my phone by the end of this.
```

需要：macOS、[tmux](https://github.com/tmux/tmux)、[ngrok](https://ngrok.com/)、Node.js 18+、[Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)

## 工作原理

```
你的手机 → Retell AI (语音转文字 + LLM) → ngrok → 桥接服务器 → claude-sessions CLI → Terminal.app → Claude Code
```

通过 [Retell AI](https://www.retellai.com/) 获取一个电话号码。打过去后，Retell 把你的语音转成文字，交给 Claude Sonnet 决定调用哪个工具，然后通过 ngrok 隧道访问你 Mac 上的桥接服务器。桥接服务器把工具调用转换成 `claude-sessions` CLI 命令——通过 AppleScript 按键注入找到对应的 Terminal.app 标签页，用 macOS kqueue 监听 JSONL 文件获取响应。

一切都在本地运行。Retell 只能看到工具调用的名称和结果。

## 功能

- **语音控制** — 打电话就能操控你的会话
- **跨会话通信** — 会话之间通过 AppleScript 按键注入互相通信
- **会话管理** — 列出、启动、终止、恢复、分叉、归档会话
- **编排器模式** — 一个主会话作为枢纽，连接 Telegram 和语音
- **Telegram 集成** — 通过手机文字消息查看会话状态
- **自动录音** — 每通电话自动录音并生成带时间戳的转写
- **电话白名单** — 只有你的号码能控制你的电脑

## 许可证

MIT
