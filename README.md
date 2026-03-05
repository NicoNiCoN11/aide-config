# Aide - OpenClaw Setup Guide

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/NicoNiCoN11/aide-config.git ~/.openclaw/workspace

# 2. Copy and edit config
cp openclaw-setup/config.template.json ~/.openclaw/openclaw.json

# 3. Edit the config with your API keys (see below)
nano ~/.openclaw/openclaw.json

# 4. Start OpenClaw
openclaw gateway start
```

## Configuration

### Required: Add Your API Keys

Edit `~/.openclaw/openclaw.json` and replace these placeholders:

| Placeholder | Description | How to get |
|-------------|-------------|------------|
| `YOUR_MINIMAX_API_KEY` | MiniMax API key | https://platform.minimax.io/ |
| `YOUR_GATEWAY_PASSWORD` | Web UI password | Choose any password |

### Adding More Models

You can add multiple model providers in `models.providers`. Here's an example:

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "minimax-cn": { ... },
      
      "openai": {
        "baseUrl": "https://api.openai.com/v1",
        "apiKey": "YOUR_OPENAI_API_KEY",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "gpt-4o",
            "name": "GPT-4O",
            "input": ["text", "image"],
            "contextWindow": 128000,
            "maxTokens": 16384
          }
        ]
      },
      
      "anthropic": {
        "baseUrl": "https://api.anthropic.com",
        "apiKey": "YOUR_ANTHROPIC_API_KEY",
        "api": "anthropic-messages",
        "authHeader": true,
        "models": [
          {
            "id": "claude-sonnet-4-20250514",
            "name": "Claude Sonnet 4",
            "reasoning": true,
            "input": ["text", "image"],
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      },
      
      "ollama": {
        "baseUrl": "http://localhost:11434",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "qwen2.5:14b",
            "name": "Qwen 2.5",
            "contextWindow": 32768,
            "maxTokens": 4096
          }
        ]
      }
    }
  }
}
```

### Switching Default Model

Change `agents.defaults.model.primary`:

```json
"model": {
  "primary": "openai/gpt-4o"
}
```

### Adding Model Aliases

```json
"models": {
  "openai/gpt-4o": {
    "alias": "gpt4"
  }
}
```

## Supported API Formats

- `anthropic-messages` - Anthropic-compatible (MiniMax, Ollama, custom endpoints)
- `openai-completions` - OpenAI completions API
- `openai-responses` - OpenAI responses API
- `google-generative-ai` - Google Gemini
- `ollama` - Local Ollama

## File Structure

```
aide-config/
├── AGENTS.md           # Agent behavior rules
├── SOUL.md             # Personality definition
├── TOOLS.md            # Tool usage notes
├── USER.md             # User profile
├── HEARTBEAT.md        # Periodic tasks
├── IDENTITY.md         # Bot identity
├── .gitignore
├── skills/             # Custom skills
└── openclaw-setup/
    ├── config.template.json
    ├── setup.sh
    └── README.md
```

## What's Included

- Core configuration files (AGENTS.md, SOUL.md, TOOLS.md, USER.md, HEARTBEAT.md, IDENTITY.md)
- Custom skills for: calendar, news, notion, whisper, pdf
- Setup automation script
