# HEARTBEAT.md - Periodic & Session Tasks

## Session Startup (every new conversation)

1. Read `~/.openclaw/memory/patterns.json`
2. Read last 3 daily summaries from `~/.openclaw/memory/daily/`
3. Check if consolidation needed (see below)
4. If morning (before 12:00 Zurich): auto-check emails and today's tasks

## Morning (8:00 AM Zurich)

1. `himalaya envelope list` → triage by priority rules in TOOLS.md
2. Query Notion: tasks due today + overdue + in-progress
3. `remindctl list` → active reminders
4. Brief Jiayi with urgent items only. Skip if nothing urgent.

## Evening (10:00 PM Zurich)

1. Generate daily summary → `~/.openclaw/memory/daily/YYYY-MM-DD.json`
2. Update `~/.openclaw/memory/patterns.json` if new patterns discovered
3. Run consolidation check

## On-Demand Triggers

| Trigger (CN) | Trigger (EN) | Action |
|-------------|-------------|--------|
| 总结 | daily summary | Generate summary immediately |
| 邮件 | check email | List and triage recent emails |
| 提醒 | reminders | List all active reminders |
| 任务 | tasks | Query Notion for today's tasks |
| 整理内存 | consolidate memory | Run memory consolidation |
| 磁盘 / 空间 | disk / storage | Check disk usage, propose cleanup |

## Daily Summary Format

```json
{
  "date": "YYYY-MM-DD",
  "tasks_completed": [],
  "tasks_failed": [],
  "lessons_learned": [],
  "new_patterns": {},
  "priority_for_tomorrow": []
}
```

Key rule: **capture ALL important information** — decisions made, preferences expressed, tool failures, and anything that should persist.

## Memory Consolidation

### Directory Structure
```
~/.openclaw/memory/
├── patterns.json       # Persistent tool patterns & preferences (always loaded)
├── daily/              # YYYY-MM-DD.json
├── weekly/             # YYYY-Www.json
└── monthly/            # YYYY-MM.json
```

### Consolidation Triggers (check at every session start + every daily summary)

```bash
daily_count=$(ls ~/.openclaw/memory/daily/*.json 2>/dev/null | wc -l | tr -d ' ')
if [ "$daily_count" -ge 7 ]; then
  # Merge oldest 7 into weekly summary → weekly/YYYY-Www.json
  # Delete those 7 daily files
fi

weekly_count=$(ls ~/.openclaw/memory/weekly/*.json 2>/dev/null | wc -l | tr -d ' ')
if [ "$weekly_count" -ge 4 ]; then
  # Merge oldest 4 into monthly summary → monthly/YYYY-MM.json
  # Delete those 4 weekly files
fi
```

### What to preserve during consolidation
- Recurring tool patterns → merge into `patterns.json` (permanent)
- User preferences discovered → merge into `patterns.json` (permanent)
- One-off task details → summarize and discard specifics
- Failed approaches → keep in `patterns.json` under `known_failures`

## Disk Space Management

Jiayi's machine has limited disk. Aide must actively manage storage.

### Disk Check (run weekly or when Jiayi says "磁盘" / "disk")

```bash
echo "=== OpenClaw Disk Usage ==="
du -sh ~/.openclaw/ 2>/dev/null
du -sh ~/.openclaw/media/ 2>/dev/null
du -sh ~/.openclaw/memory/ 2>/dev/null
du -sh ~/.openclaw/transcripts/ 2>/dev/null
du -sh ~/.cache/whisper/ 2>/dev/null
echo "=== System Disk ==="
df -h / | tail -1
```

If total OpenClaw usage > 2GB or system disk < 20% free, alert Jiayi and propose cleanup.

### Auto-Cleanup Targets (no permission needed)

| Target | Retention | Command |
|--------|-----------|---------|
| Inbound media (audio/images) | 7 days | `find ~/.openclaw/media/inbound/ -type f -mtime +7 -delete` |
| Whisper transcription outputs (.txt/.srt/.vtt) | 14 days | `find ~/.openclaw/ -name "*.srt" -o -name "*.vtt" -mtime +14 -delete` |
| Session transcripts | 30 days | `find ~/.openclaw/transcripts/ -type f -mtime +30 -delete` |
| Temp/cache files | 7 days | `find /tmp -name "openclaw*" -mtime +7 -delete 2>/dev/null` |

### Ask Permission First

| Target | When | Why |
|--------|------|-----|
| Whisper model cache | > 3GB | Jiayi may want to keep large models for accuracy |
| Old monthly memory summaries | > 6 months | May contain historically useful context |
| Specific media files | Before 7-day auto-delete | If Jiayi referenced them recently |

### Cleanup Rules

1. **Never delete `patterns.json`** — this is permanent memory
2. **Never delete files Jiayi created manually** (check ownership/path)
3. **Always verify before deleting** — `find ... -print` first, then `-delete`
4. **Log what was cleaned** — append to daily summary: `"disk_cleaned": {"media": "150MB", "transcripts": "80MB"}`
5. **Transcription before deletion** — if an audio file hasn't been transcribed yet, transcribe it before deleting

### Evening Routine Addition

Add to the evening routine (after daily summary):
```bash
# Quick media cleanup — delete processed inbound media older than 7 days
find ~/.openclaw/media/inbound/ -type f -mtime +7 -delete 2>/dev/null

# Report if disk is getting tight
disk_pct=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
if [ "$disk_pct" -gt 80 ]; then
  echo "⚠️ Disk usage at ${disk_pct}%. Recommend full cleanup."
fi
```