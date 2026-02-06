---
name: session-memory
description: "Persistent long-term memory system for conversations. Use to store and recall important context, decisions, preferences, and project state across sessions. Critical for sustained projects, user preferences, and historical context."
---

# Session Memory Skill

This skill enables long-term memory persistence across conversation sessions. Use it to maintain context about the user, their projects, preferences, and important decisions.

## Core Concept

Session memory acts like a chatbot's long-term memory—information persists beyond the current conversation and can be queried, updated, and referenced in future interactions.

## Storage Structure

Memory is organized in markdown files:
- **MEMORY.md** - Curated long-term memory (loaded in main sessions)
- **memory/YYYY-MM-DD.md** - Daily logs and raw notes
- **memory/** - Topic-specific files as needed

## When to Use

**Store in memory when:**
- User makes a decision that affects future work
- You learn something about user's preferences or workflow
- A project milestone is reached
- Important context that will be needed in future sessions
- User explicitly says "remember this"

**Read from memory when:**
- Starting a new session with the user
- Referring to past decisions or context
- Checking user preferences before acting
- Verifying project status or timeline

## Common Patterns

### Remembering Preferences
```
User: "I prefer to get reminders 5 minutes before, not 15"
→ Store in MEMORY.md under user preferences
→ Check this before setting reminders in future sessions
```

### Tracking Project Progress
```
User: "We decided to use Claude API instead of OpenAI"
→ Store in MEMORY.md as a decision
→ Reference when making implementation choices
```

### Storing Credentials and IDs
```
User provides: API keys, account IDs, server addresses
→ Store securely in memory files
→ Never output or share these
→ Reference internally only
```

## Best Practices

1. **Keep MEMORY.md curated** - Only store information worth long-term keeping
2. **Update after significant work** - After completing projects, update memory with lessons learned
3. **Daily logs first, then curate** - Write raw notes in daily files, then distill into MEMORY.md
4. **Respect privacy** - Don't leak personal information from memory files in group chats
5. **Version control** - Treat memory files like code; commit changes regularly

## Example Workflow

Session 1:
```
User: "I want to build a Telegram bot"
→ Write in memory/2026-01-30.md
→ At end of session, update MEMORY.md with goal and approach
```

Session 2:
```
User returns: "How's the bot project going?"
→ Read MEMORY.md for project status
→ Check daily logs for recent progress
→ Provide updates and next steps
```
