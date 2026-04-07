# CallClaude Launch Posts

## Hacker News (Show HN)

**Title:** Show HN: CallClaude – Control local Claude Code sessions from a phone call

**Body:**
I run 5-6 Claude Code sessions on my laptop simultaneously and kept losing track of what's running where. I wanted to check on them from my car but didn't want to build an app for the Tesla browser. So I made it a phone call.

CallClaude gives you a phone number (via Retell AI). Call it, ask "what sessions are running," and it tells you. Say "tell the main session to check the build" and it types that into the right Terminal.app tab on your Mac via AppleScript keystroke injection, then watches the JSONL conversation file with macOS kqueue for the response.

Everything runs locally. The only thing exposed is an ngrok tunnel to a bridge server that translates voice agent tool calls into CLI commands.

Tech: Retell AI (STT + Claude Sonnet + TTS) → ngrok → Express bridge server → Python CLI that reads ~/.claude/sessions/*.json and injects keystrokes via osascript.

The whole thing was built in a single Claude Code session.

https://github.com/incidentfox/callclaude

---

## Twitter/X

**Main tweet:**
I built CallClaude — control your Claude Code sessions from a phone call.

I run 5+ sessions on my laptop and lose track of what's doing what. Now I just call a number from my car and say "what's running" or "tell the main session to check the build."

Everything runs locally on your Mac. The phone call tunnels in through ngrok.

The whole thing was built in a single Claude Code session. Open source:
github.com/incidentfox/callclaude

[attach demo video]

---

## Reddit r/ClaudeAI

**Title:** I built CallClaude — control your local Claude Code sessions from a phone call (open source)

**Body:**
I run a bunch of Claude Code sessions simultaneously and kept losing track of which terminal is doing what. The moment I close my laptop, I lose all visibility.

So I built a phone number I can call to control them. It uses Retell AI for voice, Claude Sonnet as the brain, and a bridge server on my Mac that translates tool calls into claude-sessions CLI commands. The CLI finds the right Terminal.app tab by tty device path, injects keystrokes via AppleScript, and watches the JSONL file with kqueue for responses.

Everything stays local. Demo video in the README.

The fun part: the whole thing — voice agent, bridge server, CLI, cross-session messaging — was built in a single Claude Code session.

https://github.com/incidentfox/callclaude

---

## Reddit r/SideProject

**Title:** CallClaude — I built a phone number that controls my local Claude Code sessions

**Body:**
I drive a Tesla and wanted to check on my Claude Code sessions while in traffic. Didn't want to deal with getting an app on the Tesla browser. So I made it a phone call.

Call the number, say "what sessions are running" and it tells you. Say "tell the main session to check the build" and it injects that into the right terminal on your Mac. The whole thing runs locally.

Tech stack: Retell AI for voice, ngrok tunnel, Express bridge server, Python CLI with AppleScript keystroke injection.

Open source, MIT: https://github.com/incidentfox/callclaude

---

## Reddit r/selfhosted

**Title:** CallClaude — voice control for local Claude Code sessions, nothing leaves your machine

**Body:**
Built a bridge between phone calls and Claude Code sessions running on my Mac. Call a number → Retell AI transcribes → Claude Sonnet decides what to do → ngrok tunnels to a local Express server → Python CLI manages sessions via AppleScript keystroke injection into Terminal.app.

Your sessions, your machine, your terminal. Retell only sees tool call names and results. Kill ngrok and nothing is reachable. Phone number allowlist restricts who can call.

https://github.com/incidentfox/callclaude

---

## Reddit r/commandline

**Title:** claude-sessions: CLI to manage multiple Claude Code sessions + voice control via phone

**Body:**
Built a Python CLI that reads Claude Code's internal session files (~/.claude/sessions/*.json for PIDs, ~/.claude/projects/*/*.jsonl for conversation history) and lets you:

```
claude-sessions list -a                      # active sessions
claude-sessions send myapp "check build" -w  # inject message + wait
claude-sessions read myapp -n 20             # read conversation
claude-sessions fork myapp -b                # fork with full context
claude-sessions start demo ~/code -b         # new background session
```

Cross-session messaging works via AppleScript keystroke injection — finds Terminal.app tabs by tty device path, types via System Events, watches JSONL with kqueue. Also built a voice interface so you can call a phone number and talk to your sessions.

macOS only (AppleScript dependency). MIT: https://github.com/incidentfox/callclaude

---

## Product Hunt

**Tagline:** Control Claude Code from a phone call

**Description:**
CallClaude gives you a phone number that controls your local Claude Code sessions. Call it from your car, ask what's running, send commands to any session, or start new work — all by voice. Everything runs on your machine. Built in a single Claude Code session.

---

## 小红书 (Xiaohongshu)

**标题：** 堵车的时候打电话遥控我的AI写代码 太爽了

**正文：**
废话不多说直接上干货。

我平时Mac上同时开五六个Claude Code终端，一个搞自动化，一个跑测试，一个做research... 开着开着就不知道哪个窗口在干嘛了。关了笔记本更完蛋，全部失联。

所以我搞了个骚操作：给自己弄了个电话号码，打过去直接语音操控所有终端。

堵在路上的时候：
"哥们儿现在哪几个session在跑？"
"让那个主session去查一下build状态"
"开个新session跑一下测试"

原理也不复杂：Retell AI做语音识别 → Claude Sonnet当大脑决定干啥 → ngrok打隧道回你电脑 → 本地Python CLI用AppleScript往终端里打字（对，就是这么hack）

重点是：全部本地跑，你的代码你的电脑，没有任何东西上云。

最离谱的是这整个项目——语音、服务器、CLI、跨session通信——全是我让一个Claude Code session自己搭的。AI自己造了个遥控自己的工具。

开源免费：github.com/incidentfox/callclaude
README里有demo视频，1分钟看完就懂了

来个star呗老铁们 ⭐

#程序员日常 #AI写代码 #ClaudeCode #开源 #特斯拉 #效率工具

---

## 一亩三分地

**标题：** [开源] 打电话遥控本地Claude Code，堵车也能让AI给你干活

**正文：**
自报家门，湾区码农一枚。最近沉迷Claude Code没法自拔，同时开了五六个session干不同的活，搞着搞着就分不清哪个终端在干嘛了。笔记本一合更是直接失联。

试过Conductor、Agent Deck、Orca这些工具，UI太花哨反而更乱。我就想要个简单的：让我不在电脑前的时候也能管这些session。

最后想了个骚办法——搞了个电话号码，打过去就能语音操控。

为啥是电话不是app？因为我开特斯拉，懒得折腾车载浏览器装东西。电话在哪都能打，不香吗？

技术栈很土但很管用：
- Retell AI负责语音转文字+文字转语音
- Claude Sonnet当大脑决定调哪个工具
- ngrok打隧道回你Mac
- 本地Express桥接服务器转发请求
- Python CLI读Claude Code的session文件（~/.claude/sessions/*.json）
- 跨session通信靠AppleScript按键注入（没错就是找到Terminal.app的tty然后往里打字，hack到极致）
- macOS kqueue零轮询监听文件变化拿response

安全方面：API secret + 电话白名单 + ngrok随时断

全程本地跑，Retell只看得到工具调用名称和结果，看不到你代码。

最骚的是：整个项目是在一个Claude Code session里从0搭出来的。AI自己造了个遥控自己的系统。

开源MIT，README里有1分钟demo视频：github.com/incidentfox/callclaude

求star ⭐ 也欢迎提PR，目前只支持macOS（AppleScript的锅），有大佬想适配Linux的话非常欢迎
