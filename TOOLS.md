# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## CRITICAL RULES

1. **ALWAYS execute commands directly.** Never show commands for Jiayi to run manually.
2. **ALWAYS get current date/time first** before any time-related task: `date "+%Y-%m-%d %H:%M:%S %A"`
3. **NEVER repeat a failed command more than twice.** Try a different approach.
4. **NEVER ask for permission for local operations** (reminders, reading files, transcription). Just do it.
5. **If a command fails, debug silently.** Only report to Jiayi after 3 different failed attempts.

## Date & Time

- Timezone: Europe/Zurich
- Get current date: `date "+%Y-%m-%d %H:%M:%S %A"`
- Calculate tomorrow: `date -v+1d "+%Y-%m-%d"`
- Calculate next week: `date -v+7d "+%Y-%m-%d"`
- NEVER ask Jiayi what today's date is

## Apple Reminders (remindctl)

### Exact commands:
- Add reminder: `remindctl add "title" --due "YYYY-MM-DD HH:MM"`
- Add reminder for tomorrow: `remindctl add "title" --due "$(date -v+1d +%Y-%m-%d) HH:MM"`
- List all: `remindctl list`
- Delete: `remindctl delete "title"`

### Rules:
- Execute directly via bash. No permission needed.
- Always calculate the actual date first using `date` command.
- Do NOT route through WhatsApp sessions.

## Whisper Transcription

### Exact commands:
- Chinese audio: `whisper <filepath> --model base --language zh`
- English audio: `whisper <filepath> --model base --language en`
- Auto-detect: `whisper <filepath> --model base`

### Paths:
- Whisper binary: `/opt/homebrew/bin/whisper`
- Inbound media: `~/.openclaw/media/inbound/`

### Rules:
- When receiving audio/voice messages, transcribe IMMEDIATELY. No permission needed.
- Read the transcription output and respond to its content naturally.
- If whisper is not found at default path, try: `/Users/guojiayi/anaconda3/bin/whisper`

## Himalaya (Email)

### Account: gjqtime@gmail.com

### Exact commands:
- List recent emails: `himalaya envelope list`
- Read an email: `himalaya message read <ID>`
- Send an email:
  ```
  himalaya message send <<EOF
  From: gjqtime@gmail.com
  To: <recipient>
  Subject: <subject>

  <body>
  EOF
  ```
- Search emails: `himalaya envelope list --search <query>`
- List folders: `himalaya folder list`
- List sent mail: `himalaya envelope list --folder "[Gmail]/Sent Mail"`

### Rules:
- Execute directly. No permission needed for reading.
- Ask permission ONLY before sending emails to others.
- When summarizing emails, be concise: sender, subject, key action needed.

## Apple Notes (memo)

### Exact commands:
- Create note: `memo add "title" "content"`
- List notes: `memo list`
- Search: `memo search "keyword"`
- View: `memo view <id>`

## iMessage (imsg)

### Exact commands:
- List chats: `imsg chats`
- Chat history: `imsg history <chat_id>`
- Send message: `imsg send <phone_or_email> "message"`

## Web Search

- Use web search for current information, news, research papers.
- Use web fetch to read full page content after search.

## Daily Summary

At end of day or when Jiayi says "总结" / "daily summary":
1. Run: `mkdir -p ~/.openclaw/memory/daily`
2. Create: `~/.openclaw/memory/daily/YYYY-MM-DD.json`
3. **CRITICAL: Capture ALL important information:**
   - Tasks completed with details
   - Any decisions made (skills installed, rules changed, etc.)
   - Key preferences or instructions from Jiayi
   - Lessons learned (what worked, what failed)
   - Tomorrow's priorities
   - Any ongoing projects or follow-ups
4. Run memory consolidation check (see below)

## Memory Consolidation Rules

To prevent memory overflow, execute the following consolidation strategy:

### File Structure
```
~/.openclaw/memory/
├── daily/          # Daily summaries (YYYY-MM-DD.json)
├── weekly/         # Weekly summaries (YYYY-Www.json, ISO week number)
└── monthly/        # Monthly summaries (YYYY-MM.json)
```

### Consolidation Rules
1. **Every 7 days** → Check daily/ directory, if ≥7 daily summaries exist:
   - Read last 3 days of daily summaries
   - Merge into weekly summary (aggregate tasks_completed, tasks_failed, lessons_learned)
   - Save to weekly/YYYY-Www.json
   - Delete these 7 daily summary files

2. **Every 4 weeks** → Check weekly/ directory, if ≥4 weekly summaries exist:
   - Read last 4 weeks of weekly summaries
   - Merge into monthly summary
   - Save to monthly/YYYY-MM.json
   - Delete these 4 weekly summary files

### When to Execute
- Automatically check every time generating daily summary
- Or when Jiayi says "整理内存" / "consolidate memory"

### Code Logic
```bash
# Check if weekly consolidation needed
daily_count=$(ls ~/.openclaw/memory/daily/*.json 2>/dev/null | wc -l)
if [ "$daily_count" -ge 7 ]; then
    # Merge last 7 days into weekly summary
    # Delete these 7 files
fi

# Check if monthly consolidation needed  
weekly_count=$(ls ~/.openclaw/memory/weekly/*.json 2>/dev/null | wc -l)
if [ "$weekly_count" -ge 4 ]; then
    # Merge last 4 weeks into monthly summary
    # Delete these 4 files
fi
```

## Email & Messaging Rules

- **ALWAYS confirm TWICE before sending emails or messages to other people**
- Write the draft first, wait for confirmation, then send only after second confirmation
- Never send anything without explicit permission

## Error Handling Protocol

1. Command fails → check error message, adjust flags/arguments, retry ONCE
2. Second failure → try completely different tool or approach
3. Third failure → report to Jiayi concisely: "I tried X, Y, Z. All failed because [reason]. Recommend [solution]."
4. NEVER enter a loop. NEVER retry the same thing more than twice.

---

Add whatever helps you do your job. This is your cheat sheet.