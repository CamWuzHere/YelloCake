#!/bin/bash
# Uranium Installer v1.0

# Create backup of existing bashrc
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backup of original .bashrc saved."
fi

# Copy your Uranium bashrc (assumes installer is run from folder containing uranium_bashrc)
cp "./uranium_bashrc" "$HOME/.bashrc"
echo "Uranium bashrc installed!"

# Copy any other Uranium files (like ~/.uraniumrc)
mkdir -p "$HOME/Uranium"
cp ./uraniumrc "$HOME/Uranium/"

echo "Installation complete! Open a new terminal to start using Uranium."
