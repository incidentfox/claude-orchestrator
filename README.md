# CallClaude

Talk to your local Claude Code sessions from your phone.

## Why

I run a bunch of Claude Code sessions on my laptop and lose track of which terminal is doing what. I wanted to check on them from my car — but I drive a Tesla and didn't want to deal with getting an app on the Tesla browser. A phone call bypasses all of that.

## What it does

You get a phone number. Call it, say "what's running" and it tells you. Say "tell the main session to check the build" and it types that into the right terminal on your Mac. Everything stays local — your sessions run on your laptop, the bridge runs on your laptop, the phone call just tunnels in through ngrok.

```
Your phone → Retell AI → ngrok → bridge server → claude-sessions CLI → Terminal.app → Claude Code
```

Cross-session messaging works via AppleScript keystroke injection — finds the right Terminal.app tab by tty device path, types into it, watches the JSONL file with kqueue for the response. It's a hack and it works.

## Install

Fire up [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and paste:

```
Clone https://github.com/incidentfox/callclaude.git into ~/development/, read the CLAUDE.md, run setup.sh, then walk me through the full setup. I want to manage my Claude Code sessions from my phone by the end of this.
```

Requires macOS, tmux, ngrok, Node.js 18+, Claude Code CLI.

## License

MIT
