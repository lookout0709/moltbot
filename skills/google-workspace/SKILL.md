---
name: google-workspace
description: "Integrate with Google Workspace (Gmail, Google Calendar, Google Drive). Use to read emails, check calendar events, create events, send emails, and manage files—all via natural language queries."
---

# Google Workspace Skill

This skill connects to Google Workspace services: Gmail, Google Calendar, and Google Drive. Ask natural questions like "What's on my calendar tomorrow?" or "Send an email to Alice about the project."

## Setup

Requires OAuth2 authentication with Google account:

1. Run setup:
```bash
moltbot configure --section google-workspace
```

2. Select scopes needed:
   - **Gmail**: `gmail.readonly` (read emails) or `gmail.send` (send emails)
   - **Calendar**: `calendar.readonly` (read) or `calendar` (full)
   - **Drive**: `drive.readonly` (read) or `drive` (full)

3. Authorize when prompted (opens browser)

4. Credentials stored securely in `~/.moltbot/google-credentials`

## Gmail Operations

### Reading Emails
```
User: "Show me my unread emails from the last 3 days"
Bot: Queries unread emails, summarizes subjects/senders
```

### Searching
```
User: "Find emails from Alice about the project"
Bot: Searches Gmail with query: from:alice subject:project
```

### Sending
```
User: "Send an email to bob@company.com with subject 'Meeting Notes' and mention the Q1 review"
Bot: Composes and sends email
```

## Calendar Operations

### Checking Schedule
```
User: "What's on my calendar tomorrow?"
Bot: Lists all events for tomorrow with times
```

### Creating Events
```
User: "Schedule a 30-minute meeting with Alice on Friday at 2 PM"
Bot: Creates calendar event, sends invite to Alice
```

### Finding Free Time
```
User: "Find a free 1-hour slot on my calendar next week"
Bot: Scans calendar for open blocks
```

## Drive Operations

### Finding Files
```
User: "Find my Q4 budget spreadsheet"
Bot: Searches Drive by filename/type
```

### Sharing
```
User: "Share the project plan doc with the team"
Bot: Updates permissions, sends shares
```

## Query Language

Natural language queries are interpreted as:

**Gmail queries:**
- "unread" → `is:unread`
- "from Alice" → `from:alice@...`
- "subject: meeting" → `subject:meeting`
- "last 7 days" → date filter

**Calendar queries:**
- "tomorrow" → next day
- "this week" → Mon-Sun of current week
- "free slots" → gaps between events
- "all-day events" → filter by type

**Drive queries:**
- File type: "spreadsheet", "document", "pdf"
- Owner: "shared with me", "my files"
- Date: "modified last week"

## Limitations

- **Batch operations**: Limited to 100 items per query (Gmail) or 250 items (Calendar)
- **Real-time**: May be 5-10 seconds delayed due to API sync
- **Attachments**: Can list but not download large files (Drive)
- **Recurring events**: Full series handled, but individual instances have limitations

## Privacy & Security

- Credentials never logged or exposed
- Queries return only what's needed (no unnecessary data fetch)
- All operations logged with action + timestamp
- Scope-limited: bot only has access to what's authorized

## Error Handling

Common errors:
- **"Unauthorized"**: Re-authenticate with `moltbot configure --section google-workspace`
- **"Rate limited"**: Wait a few seconds before retrying
- **"Calendar not found"**: Specify calendar by name or ID
