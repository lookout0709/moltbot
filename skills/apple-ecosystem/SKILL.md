---
name: apple-ecosystem
description: "Unified Apple ecosystem integration (Reminders, Notes, Calendar, Contacts). Use to manage tasks, store notes, check calendar, and work with contacts across Apple devices."
---

# Apple Ecosystem Skill

This skill provides unified access to Apple services on Mac/iOS: Reminders, Notes, Calendar, and Contacts. Ask natural questions like "Add milk to my shopping list" or "Show me my evening events."

## Setup

Requires Mac with iCloud enabled and appropriate permissions.

### Grant Permissions
```bash
moltbot configure --section apple-ecosystem
```

Select services:
- **Reminders**: Access to default lists and custom lists
- **Notes**: Read/write to iCloud Notes
- **Calendar**: View and create events
- **Contacts**: Search and reference contacts

### Configuration
Store in `~/.moltbot/apple-config.json`:
```json
{
  "reminders": { "default_list": "Inbox" },
  "notes": { "default_folder": "Notes" },
  "calendar": { "calendar": "Personal" },
  "sync_interval": 300
}
```

## Reminders

### Adding Tasks
```
User: "Add 'Buy coffee' to my shopping list"
Bot: Creates reminder in "Shopping List"
```

### Listing Tasks
```
User: "Show my reminders for today"
Bot: Lists all reminders with due dates
```

### Organizing
```
User: "Move this task to the Weekend list"
Bot: Changes list association
```

### Smart Parsing
- "tomorrow at 10 AM" → parses to specific time
- "next Friday" → date calculation
- "high priority" → can set priority level

## Notes

### Creating Notes
```
User: "Create a note about the project kickoff"
Bot: Creates new note in default folder
```

### Searching
```
User: "Find notes about Obsidian setup"
Bot: Searches Notes, returns matching entries
```

### Organizing
```
User: "Put this in the Architecture folder"
Bot: Organizes note by folder
```

## Calendar

### Viewing Events
```
User: "What's my schedule tomorrow?"
Bot: Lists all calendar events
```

### Creating Events
```
User: "Schedule a 1-hour standup with Alice on Tuesday at 9 AM"
Bot: Creates event, sends invite if contact exists
```

### Free Time
```
User: "Find a free slot next week for a 2-hour meeting"
Bot: Scans calendar, suggests open blocks
```

## Contacts

### Searching
```
User: "What's Alice's email?"
Bot: Looks up contact, returns details
```

### Quick Reference
```
User: "Send a reminder to Alice about the meeting"
Bot: Uses contact info to create and share reminder
```

## Syncing Behavior

**Reminders & Notes**: Sync via iCloud automatically (usually 30-60 seconds)
**Calendar**: Real-time (uses system Calendar.app)
**Contacts**: Cached, refreshes every 5 minutes

### Offline Mode
- Reminders: Works offline, syncs when connected
- Notes: Cached locally, syncs when online
- Calendar: Read-only offline (read-only until sync)

## Best Practices

1. **Use specific list names** - "Add to my Backlog list" vs generic "add a reminder"
2. **Be clear with times** - "tomorrow 9 AM" not "next morning"
3. **Organize notes** - Use folders for different projects
4. **Set priorities** - High/Medium/Low for reminders that matter
5. **Check sync status** - Calendar changes visible in Calendar.app within seconds

## Limitations

- **Shared calendars**: Can read but may have permission limits for creating
- **Custom reminders lists**: Works only if they exist in Reminders.app first
- **Recurring events**: Can view, but modifying series requires Calendar.app
- **Attachments in Notes**: Can't attach files (Apple limitation)
- **Spotlight integration**: Notes search limited to title/content (no full Spotlight)

## Troubleshooting

**"Permission denied"**: Grant access in System Preferences > Security & Privacy
**"Sync not working"**: Check iCloud is enabled in System Preferences
**"Calendar event not created"**: Verify default calendar exists and is writable
**"Reminders list not found"**: Create the list in Reminders.app first
