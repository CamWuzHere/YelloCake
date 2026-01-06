#!/bin/bash
# Uranium Installer v1.0 (append mode)

URANIUMRC="$HOME/.uraniumrc"

# Copy .uraniumrc to home directory
cp "./.uraniumrc" "$URANIUMRC"
echo ".uraniumrc copied to $URANIUMRC"

# Append 'source ~/.uraniumrc' to .bashrc if not already present
if ! grep -Fxq "source $URANIUMRC" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Uranium startup" >> "$HOME/.bashrc"
    echo "source $URANIUMRC" >> "$HOME/.bashrc"
    echo "Appended 'source ~/.uraniumrc' to .bashrc"
else
    echo "'source $URANIUMRC' already present in .bashrc"
fi

echo "Installation complete! Open a new terminal to start using Uranium."
