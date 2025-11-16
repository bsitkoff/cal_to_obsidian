# Fantastical to Obsidian Calendar Exporter

Automatically export your daily calendar from Fantastical/macOS Calendar to a consistent Obsidian note that AI assistants can easily reference.

## Features

- ✅ Exports all events from your Fantastical calendar set
- 📅 Creates a consistent "Today's Calendar.md" note
- ⏰ Shows event times, titles, and source calendar
- 🤖 Automated updates throughout the day
- 🔍 Easy for AI assistants to find and reference

## Requirements

- macOS (uses EventKit framework)
- Python 3.7+
- Obsidian vault
- Fantastical (or any calendar app using macOS Calendar)

## Installation

### 1. Clone or download this repository

```bash
git clone <repository-url>
cd cal_to_obsidian
```

### 2. Run setup

```bash
chmod +x setup.sh
./setup.sh
```

This will:
- Install Python dependencies (PyObjC, PyYAML)
- Create a `config.yaml` file from the example

### 3. Configure

Edit `config.yaml` with your settings:

```yaml
# Path to your Obsidian vault
obsidian_vault_path: "~/Documents/Obsidian/MyVault"

# Note name (use consistent name for AI assistants)
calendar_note_name: "Today's Calendar.md"

# Calendar set name
calendar_set: "Bridget"

# Display options
show_calendar_name: true
show_location: true
show_notes: false
```

### 4. Test it

```bash
./cal_to_obsidian.py
```

Check your Obsidian vault for "Today's Calendar.md"!

### 5. Set up automation (optional)

To automatically update your calendar throughout the day:

```bash
chmod +x install_automation.sh
./install_automation.sh
```

This will run the export at:
- 6:00 AM (morning prep)
- 9:00 AM (workday start)
- 12:00 PM (afternoon check)
- 6:00 PM (evening update)

## Usage

### Manual Export

```bash
./cal_to_obsidian.py
```

### Test with Different Dates

You can export calendars for any date using the `--date` or `-d` flag:

```bash
# Tomorrow's calendar
./cal_to_obsidian.py --date tomorrow

# Yesterday's calendar
./cal_to_obsidian.py --date yesterday

# 3 days from now
./cal_to_obsidian.py --date +3

# Specific date (YYYY-MM-DD)
./cal_to_obsidian.py --date 2025-11-17

# Also supports MM/DD/YYYY
./cal_to_obsidian.py -d 11/17/2025

# View all options
./cal_to_obsidian.py --help
```

Perfect for testing before you set up automation!

### Check Automation Logs

```bash
tail -f logs/output.log
```

### Uninstall Automation

```bash
launchctl unload ~/Library/LaunchAgents/com.user.cal-to-obsidian.plist
rm ~/Library/LaunchAgents/com.user.cal-to-obsidian.plist
```

## Output Example

Your "Today's Calendar.md" will look like:

```markdown
# Calendar for Saturday, November 16, 2025

*Last updated: 09:00 AM*

> Note: This calendar includes events from multiple family members. Some events belong to children or other family members and may not be direct commitments for the primary user.

**3 event(s) scheduled:**

- **09:00 AM - 10:00 AM** | Team Standup *(Work)*
- **02:00 PM - 03:30 PM** | Dentist Appointment *(Personal)*
  - 📍 123 Main St, Anytown
- **06:00 PM - 07:00 PM** | Dinner with Friends *(Personal)*
  - 📍 Italian Restaurant
```

The context note at the top helps AI assistants understand that not all events may be direct commitments for you. You can customize or remove this note in `config.yaml`.

## Calendar Set Configuration

**Important Note:** macOS EventKit doesn't directly expose Fantastical's calendar sets. The script works by:

1. Accessing all calendars via EventKit (the same data Fantastical uses)
2. Optionally filtering by specific calendar names

To filter for your "Bridget" calendar set:

1. Open Fantastical
2. Note which calendars are in your "Bridget" set
3. Add them to `calendar_filter` in `config.yaml`:

```yaml
calendar_filter:
  - "Work"
  - "Personal"
  - "Family Shared"
```

Or leave it empty to include all calendars.

## Permissions

On first run, macOS will ask for permission to access your calendar. Click "OK" to allow.

If you need to reset permissions:
```bash
tccutil reset Calendar com.apple.Terminal
```

## Troubleshooting

### "No events found"
- Check that calendar_filter matches your calendar names exactly
- Try leaving calendar_filter empty to see all calendars

### "Permission denied"
- Make sure you granted Calendar access when prompted
- Check System Preferences → Security & Privacy → Calendar

### Script not running automatically
- Check logs: `tail -f logs/error.log`
- Verify launchd is loaded: `launchctl list | grep cal-to-obsidian`

## Customization

### Change update times

Edit the `StartCalendarInterval` section in your plist file:
```bash
nano ~/Library/LaunchAgents/com.user.cal-to-obsidian.plist
```

Then reload:
```bash
launchctl unload ~/Library/LaunchAgents/com.user.cal-to-obsidian.plist
launchctl load ~/Library/LaunchAgents/com.user.cal-to-obsidian.plist
```

### Change note name

Edit `calendar_note_name` in `config.yaml`. You can use date formatting:
```yaml
calendar_note_name: "%Y-%m-%d-Calendar.md"  # Creates: 2025-11-16-Calendar.md
```

### Add more event details

Set `show_notes: true` in config.yaml to include event descriptions.

### Customize the context note for AI assistants

Edit `context_note` in `config.yaml` to help AI assistants understand your calendar:

```yaml
# Example: Emphasize that some events are informational only
context_note: "Note: This calendar includes family events and subscribed calendars. Not all events require my direct involvement."

# Example: Explain calendar categories
context_note: "Context for AI: Events from 'Kids School' and 'Family' calendars are for awareness. Only 'Work' and 'Personal' are my direct commitments."

# Leave empty to hide the note
context_note: ""
```

## License

MIT

## Contributing

Issues and pull requests welcome!
