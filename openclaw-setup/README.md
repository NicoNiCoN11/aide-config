# Aide Setup Guide

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/NicoNiCoN11/aide-config.git ~/.openclaw/workspace

# 2. Copy and edit config
cp openclaw-setup/config.template.json ~/.openclaw/openclaw.json
# Edit the file and add your API keys

# 3. Start OpenClaw
openclaw gateway start
```

## Required API Keys

### MiniMax API
Get your API key from: https://platform.minimax.io/

Edit `~/.openclaw/openclaw.json` and replace `YOUR_API_KEY_HERE` with your actual key.

## What's Included

- `AGENTS.md`, `SOUL.md`, `TOOLS.md`, `USER.md` - Core configuration files
- `skills/` - Custom skills
- `openclaw-setup/` - Setup templates

## File Structure

```
aide-config/
├── AGENTS.md
├── SOUL.md
├── TOOLS.md
├── USER.md
├── HEARTBEAT.md
├── IDENTITY.md
├── .gitignore
├── skills/
│   └── ...
└── openclaw-setup/
    ├── config.template.json
    └── README.md
```
