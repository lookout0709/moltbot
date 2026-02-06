---
name: command-logger
description: "Log all executed commands, API calls, and tool invocations for audit, debugging, and reconstruction. Use to track what was run, when, why, and what the outcome was."
---

# Command Logger Skill

This skill maintains a structured log of all commands, API calls, tool invocations, and actions taken during bot sessions. It's essential for debugging, auditing, and understanding what happened.

## Log Structure

Logs are stored in `logs/` directory with daily files:
```
logs/
├── 2026-01-30.md
├── 2026-01-31.md
└── commands.jsonl (optional: structured format)
```

## What Gets Logged

Every entry includes:
- **Timestamp** - When the command ran
- **Type** - Command type (shell, API, tool, file operation)
- **Command** - The exact command or call
- **Context** - Why it was run (user request, automated task)
- **Result** - Exit code, output, or error
- **Duration** - How long it took

## Log Entry Format

```markdown
## 2026-01-30 14:35:22 - Command Type

**User request:** "Search for Obsidian plugins"
**Command:** `Get-ChildItem -Path "C:\vault" -Recurse`
**Context:** User asked to find files
**Exit code:** 0
**Output:** [truncated for brevity] 127 results found
**Duration:** 234ms
```

## Usage Patterns

### Debugging Failed Operations
When something breaks:
1. Check logs for recent commands
2. Review exit codes and error messages
3. Reproduce the command manually
4. Identify root cause

Example:
```
2026-01-30 15:42:01 - Command Failed
Command: git push origin main
Exit code: 1
Error: fatal: No such remote 'origin'
→ Indicates git not properly initialized
```

### Auditing Sensitive Operations
Track all file deletions, credential usage, API calls:

```
2026-01-30 16:00:15 - Delete File (Sensitive)
Command: rm /tmp/sensitive.txt
Context: User-requested cleanup
Confirmed: Yes
Duration: 45ms
```

### Performance Monitoring
Identify slow operations:

```
Command: tar -czf backup.tar.gz /data
Duration: 45230ms (45+ seconds)
→ Consider optimizing next time
```

## Integration with Session Memory

Commands that affect memory files are logged separately:
```
2026-01-30 16:15:30 - Memory Update
File: MEMORY.md
Change: Added project milestone
Size delta: +342 bytes
Committed: Yes
```

## Best Practices

1. **Be specific with context** - Log why a command ran, not just that it ran
2. **Truncate large output** - Keep logs readable, store full output separately if needed
3. **Mark sensitive commands** - Flag API calls, credential operations
4. **Review regularly** - Check logs weekly to catch patterns or issues
5. **Clean up periodically** - Archive old logs to keep active log manageable

## Querying Logs

Common queries:
- "Show all failed commands from today"
- "Find the last API call to endpoint X"
- "List all file deletions this week"
- "Show commands that took >10 seconds"

## Log Retention

- **Active logs**: 30 days
- **Archive**: 6 months (compressed)
- **Retention**: Configurable per environment
