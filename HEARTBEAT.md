# HEARTBEAT.md - Periodic Tasks

## Every Morning (8:00 AM Zurich time)
- Check new emails: `himalaya envelope list`
- Check today's reminders: `remindctl list`
- If Jiayi has sent messages overnight, summarize them

## Every Evening (10:00 PM Zurich time)
- Generate daily summary to `~/.openclaw/memory/daily/YYYY-MM-DD.json`
- Review what worked and what failed today
- Update TOOLS.md if new command patterns were discovered

## On Demand
- When Jiayi says "总结" or "daily summary", generate summary immediately
- When Jiayi says "邮件" or "check email", list and summarize recent emails
- When Jiayi says "提醒" or "reminders", list all active reminders