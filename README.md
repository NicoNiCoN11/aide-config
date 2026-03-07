# Aide - OpenClaw Configuration (Optimized)

## Architecture

```
aide-config/
├── IDENTITY.md         # Bot identity (minimal)
├── SOUL.md             # Personality & philosophy
├── AGENTS.md           # Execution rules (single source of truth)
├── USER.md             # User profile & context
├── TOOLS.md            # Tool reference, workflows, email triage
├── HEARTBEAT.md        # Periodic tasks, memory & disk management
├── patterns.json       # → copy to ~/.openclaw/memory/patterns.json
├── .gitignore
├── skills/
│   ├── apple-reminders-advanced/   # Sub-tasks, tags, batch ops via JXA
│   └── reminders-calendar-sync/    # Reminders ↔ gcal time block sync
└── openclaw-setup/
    ├── config.template.json
    └── README.md
```

## Design Principles

1. **No redundancy.** Each rule lives in exactly one file. Other files reference, not repeat.
2. **Token-efficient.** All config files are loaded into context every session. Every word costs tokens.
3. **Native-first task management.** Apple Reminders = tasks (sub-tasks, tags, priority). Google Calendar = time blocks. Notion = project docs.
4. **Persistent learning.** `patterns.json` survives across sessions. Daily summaries are temporary and get consolidated.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/NicoNiCoN11/aide-config.git ~/.openclaw/workspace

# 2. Config
cp openclaw-setup/config.template.json ~/.openclaw/openclaw.json
nano ~/.openclaw/openclaw.json  # add API keys

# 3. Initialize memory
mkdir -p ~/.openclaw/memory/{daily,weekly,monthly}
cp patterns.json ~/.openclaw/memory/patterns.json

# 4. Set up Reminders lists (agent will auto-create on first use, or run manually):
# PhD申请, 实习, 行政, 个人, 学习, 项目

# 5. Start
openclaw gateway start
```

## Model Configuration

Primary: MiniMax M2.5 (via API)
- Strong agentic tool calling (BFCL 76.9%)
- 1M token context window
- Cost-effective ($0.3/M input, $2.4/M output)

**Important:** M2.5 uses interleaved thinking (`<think>` tags). Always preserve full assistant messages in conversation history to maintain reasoning chain continuity.

## Token Budget Notes

- All bootstrap files: ~2500 tokens total (down from ~5000+ before optimization)
- Skills loaded on-demand, not at startup
- Consolidation keeps memory files bounded
- Suggest new session after ~15 turns to avoid context overflow