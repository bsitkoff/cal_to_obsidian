#!/bin/bash
# Install launchd automation for daily calendar export

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLIST_NAME="com.user.cal-to-obsidian"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"

echo "🤖 Installing automation for Fantastical to Obsidian..."

# Get Python path
PYTHON_PATH=$(which python3)

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$HOME/Library/LaunchAgents"

# Create the plist file
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_NAME}</string>

    <key>ProgramArguments</key>
    <array>
        <string>${PYTHON_PATH}</string>
        <string>${SCRIPT_DIR}/cal_to_obsidian.py</string>
    </array>

    <key>WorkingDirectory</key>
    <string>${SCRIPT_DIR}</string>

    <key>StartCalendarInterval</key>
    <array>
        <!-- Run at 6:00 AM -->
        <dict>
            <key>Hour</key>
            <integer>6</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
        <!-- Run at 9:00 AM -->
        <dict>
            <key>Hour</key>
            <integer>9</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
        <!-- Run at 12:00 PM -->
        <dict>
            <key>Hour</key>
            <integer>12</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
        <!-- Run at 6:00 PM -->
        <dict>
            <key>Hour</key>
            <integer>18</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
    </array>

    <key>StandardOutPath</key>
    <string>${SCRIPT_DIR}/logs/output.log</string>

    <key>StandardErrorPath</key>
    <string>${SCRIPT_DIR}/logs/error.log</string>

    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Create logs directory
mkdir -p "${SCRIPT_DIR}/logs"

# Load the launch agent
echo "📋 Loading launch agent..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ Automation installed successfully!"
echo ""
echo "The calendar will be exported automatically at:"
echo "  - 6:00 AM"
echo "  - 9:00 AM"
echo "  - 12:00 PM"
echo "  - 6:00 PM"
echo ""
echo "Logs are stored in: ${SCRIPT_DIR}/logs/"
echo ""
echo "To manually run: ./cal_to_obsidian.py"
echo "To uninstall: launchctl unload ${PLIST_PATH}"
echo ""
