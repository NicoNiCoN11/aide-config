---
name: apple-reminders-advanced
description: "Advanced Apple Reminders management via remindctl + osascript. Use when Jiayi needs sub-tasks, tags, batch postpone, or any operation beyond basic add/edit/delete. Replaces Notion for day-to-day task management."
---

# Apple Reminders — Advanced Operations

## Tool Selection

| Operation | Tool | Why |
|-----------|------|-----|
| Add/edit/complete/delete single reminder | `remindctl` | Fast, simple |
| View by date/list | `remindctl` | Built-in filtering |
| Create sub-tasks | `osascript -l JavaScript` | remindctl doesn't support |
| Add/remove tags | `osascript -l JavaScript` | remindctl doesn't support |
| Batch postpone | `osascript -l JavaScript` | Need loop + date math |
| Query by tag | `osascript -l JavaScript` | remindctl doesn't support |
| Priority management | `remindctl` or `osascript` | Both work |

## List Structure (as categories)

Use Reminders Lists as top-level categories:

| List | Purpose |
|------|---------|
| PhD申请 | All PhD application tasks |
| 实习 | Internship search tasks |
| 行政 | Admin, paperwork, university bureaucracy |
| 个人 | Personal errands, life stuff |
| 学习 | Study, reading, skill-building |
| 项目 | Research projects, code projects |

Create lists on first use:
```bash
remindctl list PhD申请 --create
remindctl list 实习 --create
remindctl list 行政 --create
remindctl list 个人 --create
remindctl list 学习 --create
remindctl list 项目 --create
```

## Tag Convention

Tags provide cross-list filtering. Convention:

| Tag | Meaning |
|-----|---------|
| #urgent | Needs attention today |
| #waiting | Blocked on someone else |
| #deadline-Xd | Has a hard deadline in X days |
| #<program-name> | e.g. #EMBL, #MPI-Berlin, #NUS |
| #gcal-synced | Has a corresponding Google Calendar event |

## Basic Operations (remindctl)

```bash
# Add to specific list
remindctl add --title "Write EMBL motivation letter" --list PhD申请 --due 2026-03-15

# View by list
remindctl list PhD申请

# View today / this week
remindctl today
remindctl week

# Edit
remindctl edit <ID> --title "New title" --due 2026-03-20

# Complete
remindctl complete <ID>

# View overdue
remindctl overdue
```

## Advanced Operations (osascript/JXA)

### Add reminder with sub-tasks

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const list = app.lists.byName("PhD申请");

// Create parent reminder
const parent = app.Reminder({
  name: "EMBL PhD Application",
  dueDate: new Date("2026-04-01T09:00:00"),
  priority: 1  // 1=high, 5=medium, 9=low, 0=none
});
list.reminders.push(parent);

// Create sub-tasks
const subtasks = [
  "Write motivation letter",
  "Contact 2 recommenders",
  "Update CV",
  "Prepare research statement"
];
subtasks.forEach(title => {
  const sub = app.Reminder({ name: title });
  parent.reminders.push(sub);
});

`Created "${parent.name()}" with ${subtasks.length} sub-tasks`;
EOF
```

### Add tags to a reminder

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const list = app.lists.byName("PhD申请");
const reminders = list.reminders.whose({name: {_contains: "EMBL"}});

if (reminders.length > 0) {
  const r = reminders[0];
  // Tags are stored as an array
  const existingTags = r.tags() || [];
  const newTags = [...new Set([...existingTags, "EMBL", "urgent"])];
  r.tags = newTags;
  `Tagged "${r.name()}" with: ${newTags.join(", ")}`;
} else {
  "No matching reminder found";
}
EOF
```

### Query reminders by tag

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const targetTag = "EMBL";
const results = [];

app.lists().forEach(list => {
  list.reminders.whose({completed: false})().forEach(r => {
    const tags = r.tags() || [];
    if (tags.includes(targetTag)) {
      const due = r.dueDate() ? r.dueDate().toISOString().slice(0,10) : "no date";
      results.push(`[${list.name()}] ${r.name()} (due: ${due})`);
    }
  });
});

results.length > 0 ? results.join("\n") : `No reminders tagged #${targetTag}`;
EOF
```

### Batch postpone (by list or tag)

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const listName = "PhD申请";  // or use tag filter
const daysToPostpone = 7;
const list = app.lists.byName(listName);
let count = 0;

list.reminders.whose({completed: false})().forEach(r => {
  const due = r.dueDate();
  if (due) {
    const newDue = new Date(due.getTime() + daysToPostpone * 86400000);
    r.dueDate = newDue;
    count++;
  }
});

`Postponed ${count} reminders in "${listName}" by ${daysToPostpone} days`;
EOF
```

### Batch postpone by tag

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const targetTag = "EMBL";
const daysToPostpone = 14;
let count = 0;

app.lists().forEach(list => {
  list.reminders.whose({completed: false})().forEach(r => {
    const tags = r.tags() || [];
    if (tags.includes(targetTag) && r.dueDate()) {
      const newDue = new Date(r.dueDate().getTime() + daysToPostpone * 86400000);
      r.dueDate = newDue;
      count++;
    }
  });
});

`Postponed ${count} reminders tagged #${targetTag} by ${daysToPostpone} days`;
EOF
```

### Batch add tag

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const listName = "PhD申请";
const tagToAdd = "deadline-7d";
const list = app.lists.byName(listName);
let count = 0;

list.reminders.whose({completed: false})().forEach(r => {
  const tags = r.tags() || [];
  if (!tags.includes(tagToAdd)) {
    r.tags = [...tags, tagToAdd];
    count++;
  }
});

`Added #${tagToAdd} to ${count} reminders in "${listName}"`;
EOF
```

### List all sub-tasks of a reminder

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const list = app.lists.byName("PhD申请");
const parent = list.reminders.whose({name: {_contains: "EMBL"}})[0];
const subs = parent.reminders();

const result = [`📋 ${parent.name()} [${parent.completed() ? "✅" : "⬜"}]`];
subs.forEach(s => {
  result.push(`  ${s.completed() ? "✅" : "⬜"} ${s.name()}`);
});
result.join("\n");
EOF
```

### Overview: all incomplete tasks with tags

```bash
osascript -l JavaScript << 'EOF'
const app = Application("Reminders");
const results = [];

app.lists().forEach(list => {
  const incomplete = list.reminders.whose({completed: false})();
  if (incomplete.length === 0) return;
  
  results.push(`\n📁 ${list.name()} (${incomplete.length})`);
  incomplete.forEach(r => {
    const due = r.dueDate() ? r.dueDate().toISOString().slice(0,10) : "";
    const tags = (r.tags() || []).map(t => `#${t}`).join(" ");
    const pri = r.priority() === 1 ? "🔴" : r.priority() === 5 ? "🟡" : "";
    results.push(`  ${pri} ${r.name()} ${due} ${tags}`.trim());
  });
});

results.join("\n") || "No incomplete reminders";
EOF
```

## Calendar Sync Workflow

When a task needs a time block on Google Calendar:

1. Create reminder normally (remindctl or osascript)
2. Add tag `#gcal-synced`
3. Create corresponding gcal event: `gcalcli --nocolor --calendar "Cal" add --noprompt --title "Title" --when "Start" --duration Minutes`
4. When postponing: update both reminder due date AND gcal event (delete+recreate)

## Common User Requests → Actions

| User says | Action |
|-----------|--------|
| "帮我建个XX任务，子任务有..." | osascript: create parent + sub-tasks |
| "把PhD申请的任务延后一周" | osascript: batch postpone by list |
| "给所有EMBL相关的任务加个tag" | osascript: batch add tag |
| "今天有什么任务" | `remindctl today` |
| "这周的overdue有哪些" | `remindctl overdue` |
| "把XX标记完成" | `remindctl complete <ID>` |
| "我放假了，所有任务延后5天" | osascript: batch postpone all lists |
| "显示所有带#urgent标签的任务" | osascript: query by tag |

## Error Handling

- If osascript fails with "not authorized": `remindctl authorize` then retry
- If list doesn't exist: create it first with `remindctl list <name> --create`
- If reminder not found by name: try partial match with `_contains`
- JXA `whose()` returns a reference — always call `()` to materialize: `.whose({...})()`