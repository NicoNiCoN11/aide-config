#!/bin/bash

# Aide - OpenClaw Setup Script

set -e

echo "Setting up Aide..."

# 1. Install OpenClaw if not already installed
if ! command -v openclaw &> /dev/null; then
    echo "Installing OpenClaw..."
    npm install -g openclaw
fi

# 2. Create workspace directory
mkdir -p ~/.openclaw/workspace

# 3. Copy config template
if [ ! -f ~/.openclaw/openclaw.json ]; then
    echo "Copying config template..."
    cp config.template.json ~/.openclaw/openclaw.json
    echo "⚠️  Please edit ~/.openclaw/openclaw.json and add your API keys!"
fi

# 4. Copy workspace files
echo "Copying workspace files..."
cp -r skills/ ~/.openclaw/workspace/
cp AGENTS.md SOUL.md TOOLS.md USER.md HEARTBEAT.md IDENTITY.md ~/.openclaw/workspace/
cp .gitignore ~/.openclaw/workspace/

echo "✅ Setup complete!"
echo ""
echo "To start Aide, run:"
echo "  openclaw gateway start"
