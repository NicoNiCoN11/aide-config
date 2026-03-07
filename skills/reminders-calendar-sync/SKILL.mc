---
name: reminders-calendar-sync
description: "Sync workflow between Apple Reminders (task system) and Google Calendar (time blocks). Use when Jiayi wants to block time for a task, or when batch-postponing tasks that have calendar events."
---

# Reminders ↔ Calendar Sync

## When to Sync

- Jiayi says "安排到日历里" / "block time for this" → create gcal event + tag #gcal-synced
- Jiayi batch-postpones tasks → also update synced gcal events
- Due date ≠ calendar event. Only sync when Jiayi explicitly wants a time block.

## Create Time Block for a Task

1. Ensure reminder exists (create if needed)
2. Tag it with #gcal-synced via osascript
3. Check overlap: `gcalcli --nocolor agenda start end` (no --calendar flag)
4. Create gcal event: `gcalcli --nocolor --calendar "Cal" add --noprompt --title "Title" --when "Start" --duration Minutes`

## Batch Postpone with Calendar Sync

1. Postpone reminders via osascript (batch postpone script in apple-reminders-advanced)
2. Query all reminders tagged #gcal-synced that were postponed
3. For each: delete old gcal event + create new one at new date + verify
4. Report: "已延后 X 个任务，Y 个日历事件已同步"

## Find All Synced Tasks

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const results = [];
app.lists().forEach(list => {
  list.reminders.whose({completed: false})().forEach(r => {
    if ((r.tags() || []).includes("gcal-synced")) {
      const due = r.dueDate() ? r.dueDate().toISOString().slice(0,10) : "no date";
      results.push(`[${list.name()}] ${r.name()} (${due})`);
    }
  });
});
results.join("\n") || "No calendar-synced reminders";
EOF
```