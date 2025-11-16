#!/bin/bash
# Setup script for Fantastical to Obsidian Calendar Exporter

set -e

echo "🚀 Setting up Fantastical to Obsidian Calendar Exporter..."

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not found. Please install it first."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not found. Please install it first."
    exit 1
fi

echo "✅ pip3 found"

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

# Create config file if it doesn't exist
if [ ! -f config.yaml ]; then
    echo "📝 Creating config.yaml from example..."
    cp config.example.yaml config.yaml
    echo "⚠️  Please edit config.yaml with your Obsidian vault path before running!"
else
    echo "✅ config.yaml already exists"
fi

# Make the main script executable
chmod +x cal_to_obsidian.py

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit config.yaml with your Obsidian vault path"
echo "2. Run: ./cal_to_obsidian.py to test"
echo "3. Run: ./install_automation.sh to set up daily automation"
echo ""
