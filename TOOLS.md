# TOOLS.md - Tool Reference & Workflows

## Date & Time

- Timezone: Europe/Zurich
- Current datetime: `date "+%Y-%m-%d %H:%M:%S %A"`
- Tomorrow: `date -v+1d "+%Y-%m-%d"`
- Next week: `date -v+7d "+%Y-%m-%d"`
- Timezone conversion: `TZ="Asia/Singapore" date -d "2026-03-10 14:00 CET" "+%Y-%m-%d %H:%M %Z"`
- NEVER ask Jiayi what today's date is. Always compute it.

## Apple Reminders (Task Management — Primary System)

> Full reference: `skills/apple-reminders-advanced/SKILL.md` — read before sub-tasks, tags, or batch ops.

Apple Reminders is the **primary task management system**. Google Calendar is only for time-block visualization.

**Basic ops → remindctl (fast):**
```bash
remindctl add --title "Title" --list "PhD申请" --due "2026-03-15 09:00"
remindctl today                    # today's tasks
remindctl week                     # this week
remindctl overdue                  # overdue
remindctl list PhD申请              # view specific list
remindctl edit <ID> --title "X" --due "2026-03-20"
remindctl complete <ID>
remindctl delete <ID> --force
```

**Advanced ops → osascript -l JavaScript (sub-tasks, tags, batch):**
- Create sub-tasks, add/query tags, batch postpone, batch tag → see skill SKILL.md
- Always use `osascript -l JavaScript << 'EOF' ... EOF` pattern

**Lists as categories:** PhD申请, 实习, 行政, 个人, 学习, 项目

**Rules:**
- Execute directly. No permission needed.
- Always calculate date first.
- Default time if unspecified: 09:00 Zurich.
- Tag convention: #urgent, #waiting, #gcal-synced, #<program-name>

## Google Calendar (gcalcli)

> Full reference: `skills/gcalcli-calendar/SKILL.md` — read before complex operations.

Google Calendar is for **time blocks only**, not task tracking.

Common commands:
```bash
# Today's agenda
gcalcli --nocolor agenda today tomorrow

# Next 14 days (for weekday resolution)
gcalcli --nocolor agenda today +14d

# Create event
gcalcli --nocolor --calendar "CalName" add --noprompt --title "Title" --when "Start" --duration Minutes

# Delete (non-interactive) + verify
gcalcli --nocolor delete --iamaexpert "query" start end
gcalcli --nocolor agenda start end  # verify deletion
```

Key rules:
- Global flags (`--nocolor`, `--calendar`) go BEFORE subcommand.
- Subcommand flags (`--iamaexpert`, `--noprompt`) go AFTER subcommand.
- `edit` is interactive → cannot use. Always delete+recreate.
- Overlap check before create: `gcalcli --nocolor agenda start end` (NO `--calendar` flag — must be cross-calendar).
- Deleting >2 events at once → ask Jiayi for confirmation.

## Notion (Reference / Long-form Notes — Secondary)

> Full reference: `skills/notion-api-skill/SKILL.md` — read before first use.

Use Notion for **project-level documentation**, not daily tasks. Examples: PhD application tracker with notes per program, research reading logs, internship company research.

- API pattern: Use `python << 'EOF'` (not curl pipe) to avoid env variable issues.
- Always use Notion-Version: 2025-09-03.

## Himalaya (Email)

Account: gjqtime@gmail.com

```bash
himalaya envelope list                              # recent emails
himalaya message read <ID>                          # read email
himalaya envelope list --search <query>             # search
himalaya folder list                                # list folders
himalaya envelope list --folder "[Gmail]/Sent Mail" # sent mail

# Send (permission required)
himalaya message send <<EOF
From: gjqtime@gmail.com
To: <recipient>
Subject: <subject>

<body>
EOF
```

### Email Triage Rules

When checking emails, classify and report by priority:

| Priority | Criteria | Action |
|----------|----------|--------|
| 🔴 Urgent | From PI/professor, contains deadline within 7 days, interview invitation | Notify immediately with summary |
| 🟡 Important | PhD program correspondence, internship responses, admin with deadline | Summarize, flag deadline |
| 🟢 Normal | Confirmations, receipts, university newsletters | Brief one-line summary |
| ⚪ Skip | Marketing, ads, automated notifications | Don't mention unless asked |

### Email Compose Style

| Recipient | Style |
|-----------|-------|
| Professor/PI | 简洁专业。第一句话直接说目的。不用Dear/Best regards，用 "Hi Prof. X" / "Best, Jiayi" |
| 行政/大学 | 正式简短。包含学号/reference number如果有 |
| 同学/朋友 | 随意 |

- Always draft first, show to Jiayi, send only after explicit approval.
- If replying, quote the relevant context briefly.

## Whisper (Transcription)

```bash
whisper <filepath> --model base --language zh    # Chinese
whisper <filepath> --model base --language en    # English
whisper <filepath> --model base                  # auto-detect
```

- Paths: `/opt/homebrew/bin/whisper` or `/Users/guojiayi/anaconda3/bin/whisper`
- Inbound media: `~/.openclaw/media/inbound/`
- Model cache: `~/.cache/whisper/` (base ~150MB, medium ~1.5GB, large ~3GB)
- Transcribe voice messages IMMEDIATELY. No permission needed.
- After transcription, respond to the content directly.
- **Disk rule:** Default to `base` model. Only use `medium`/`large` if Jiayi explicitly asks for higher accuracy. Don't download larger models without asking.

## Apple Notes (memo)

```bash
memo add "title" "content"
memo list
memo search "keyword"
memo view <id>
```

## iMessage (imsg)

```bash
imsg chats
imsg history <chat_id>
imsg send <phone_or_email> "message"   # permission required
```

## Web Search

- Use for current information, news, research papers, PI publications, program deadlines.
- After search, use web fetch to read full page content.
- Useful for: checking PI's latest papers, verifying program deadlines, looking up application portals.

## Error Handling

1. First failure → check error, adjust flags, retry once
2. Second failure → completely different tool or approach
3. Third failure → report to Jiayi: "Tried X, Y, Z. Failed because [reason]. Recommend [solution]."
4. NEVER loop. NEVER retry same thing > twice.