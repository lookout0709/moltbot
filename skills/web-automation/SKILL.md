---
name: web-automation
description: "Automate web browser tasks: navigate sites, fill forms, extract data, take screenshots, scrape content. Use for workflow automation, data collection, and website interaction."
---

# Web Automation Skill

This skill controls a web browser to automate web tasks: navigate pages, fill forms, extract data, wait for content, and scrape information. Perfect for repetitive workflows and data gathering.

## Browser Control

### Navigation
```
User: "Go to github.com/moltbot/moltbot and take a screenshot"
Bot: Opens URL, takes screenshot, returns image
```

### Filling Forms
```
User: "Fill the search box with 'moltbot' and press Enter"
Bot: Types in input field, submits form
```

### Extracting Data
```
User: "Get all the PR titles from this page"
Bot: Parses HTML, returns list of titles
```

## Core Operations

### Navigate
Navigate to a URL:
```
navigate(url="https://github.com")
```

### Click
Click an element by role, name, or selector:
```
click(ref="button", text="Search")
```

### Type
Enter text into a field:
```
type(ref="input", text="moltbot")
```

### Extract
Get text content from elements:
```
extract(selector=".repository-name", format="list")
```

### Wait
Wait for content to appear:
```
wait(text="Loading complete", timeout=5000)
```

### Screenshot
Take a screenshot of current page:
```
screenshot(fullPage=true)
```

## Scraping Patterns

### Table Extraction
```
User: "Extract the table from this page"
Bot: Finds all table rows, converts to CSV
```

### Link Harvesting
```
User: "Get all links from this page"
Bot: Finds all `<a>` tags, returns URLs with text
```

### Content Scraping
```
User: "Get all article titles and dates"
Bot: Parses structure, returns formatted list
```

## Advanced Features

### Multiple Tabs
```
User: "Open 3 tabs: Google, GitHub, and Gmail"
Bot: Opens multiple tabs, can switch between them
```

### Wait for Conditions
```
User: "Wait until the page fully loads, then take a screenshot"
Bot: Waits for network idle, takes screenshot
```

### JavaScript Execution
```
User: "Get the dark mode preference from localStorage"
Bot: Executes JS, returns result
```

### Viewport Control
```
User: "Show me what this looks like on mobile"
Bot: Sets viewport to iPhone dimensions, takes screenshot
```

## Practical Examples

### GitHub Workflow
```
1. Navigate to repo
2. Find latest PR
3. Extract PR details (title, author, status)
4. Return structured data
```

### Form Automation
```
1. Navigate to form page
2. Fill email field
3. Fill password field
4. Click submit
5. Wait for confirmation
6. Extract success message
```

### Data Collection
```
1. Loop through paginated results
2. Extract data from each page
3. Combine results
4. Return as CSV or JSON
```

## Selectors

Multiple ways to reference elements:

**By role** (recommended):
```
click(ref="button", text="Submit")
```

**By CSS selector**:
```
click(selector=".submit-button")
```

**By XPath**:
```
click(xpath="//button[@type='submit']")
```

**By visible text**:
```
click(text="Click me")
```

## Waits & Timing

### Wait Types
- **URL change**: `wait(urlContains="/success")`
- **Element**: `wait(selector=".confirmation")`
- **Text**: `wait(text="Success")`
- **Stability**: Wait until page stops changing

### Timeout
Default: 10 seconds, customizable:
```
wait(text="Done", timeout=30000)  # 30 seconds
```

## Data Output Formats

### Structured Extraction
```
extract(format="json")   # Return as JSON object
extract(format="csv")    # Return as CSV
extract(format="html")   # Return as HTML snippet
extract(format="text")   # Return as plain text
```

## Privacy & Security

- **No credential storage**: Don't auto-fill passwords
- **Limited scope**: Only access what user requests
- **Transparent logging**: Log all navigation for audit
- **Session isolation**: Each session is separate

## Limitations

- **JavaScript-heavy sites**: May need extra wait time
- **Authentication**: Can fill forms but not auto-login securely
- **Downloads**: Can't download files directly (browser limit)
- **Video/media**: Can't interact with embedded media
- **Rate limiting**: Respect site's robots.txt and rate limits

## Error Handling

**"Element not found"**: Element may not exist, page may still be loading
**"Timeout"**: Page took too long to load or element never appeared
**"Navigation failed"**: URL invalid or network error
**"Permission denied"**: Site blocked automation

Retry logic should include:
1. Increase timeout
2. Add explicit wait before action
3. Try alternative selector
4. Check if page structure changed
