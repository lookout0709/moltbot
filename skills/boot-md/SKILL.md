---
name: boot-md
description: "Auto-load Markdown guidelines and rules at startup. Use to define bot personality, behavioral rules, system prompts, and operational procedures that should be read before every session."
---

# Boot MD Skill

This skill automatically loads a bootstrap Markdown file at startup, establishing the bot's personality, rules, and operational context before processing any requests.

## Purpose

Instead of hardcoding personality and rules, boot-md loads configuration from a readable, user-editable Markdown file. This allows you to:

- Define bot personality and tone
- Set operational rules (what to do/not do)
- Establish context about the user and environment
- Update behavior without code changes

## Bootstrap File Location

The bot looks for bootstrap config in this order:
1. `BOOT.md` in workspace root
2. `BOOT.md` in HOME directory
3. System default (if neither exists)

## Standard Sections

```markdown
# BOOT.md - Bot Configuration

## Identity
- Name: [bot name]
- Personality: [personality traits]
- Emoji: [signature emoji]

## Rules
- Do: [allowed behaviors]
- Don't: [forbidden behaviors]

## User Context
- Name: [user info]
- Timezone: [location/timezone]
- Preferences: [user preferences]

## Operational
- Response style: [concise/detailed/etc]
- Default actions: [auto-approve/ask first/etc]
```

## Example BOOT.md

```markdown
# Boot Configuration

## Identity
- Name: Mia
- Personality: Direct, helpful, no fluff
- Emoji: 🎯

## Rules
- Always be honest about what you don't know
- Ask before executing external actions (emails, API calls)
- Keep responses under 500 words unless user asks for more

## User Context
- Name: Alex
- Timezone: America/New_York
- Key interest: Full-stack development

## Operational
- Default: Ask before significant changes
- Caching: 24 hours for non-critical queries
- Logging: All decisions logged to memory
```

## Loading Behavior

On startup:
1. Check for BOOT.md in workspace or HOME
2. Load and parse Markdown
3. Extract key sections (Identity, Rules, User Context)
4. Apply to session context
5. Reference throughout conversation

## Dynamic Updates

You can update BOOT.md mid-session:
- Changes apply to next session (requires restart)
- For immediate changes, use inline instructions

## Integration with Other Skills

Boot-md works alongside:
- **session-memory**: BOOT.md sets initial context; memory files persist decisions
- **command-logger**: BOOT.md rules are logged alongside commands
