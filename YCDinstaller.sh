#!/bin/bash
if curl -sSL https://raw.githubusercontent.com/CamWuzHere/YelloCake/main/.YelloCakeDev -o ~/.YelloCakeDev; then
    echo "Downloaded .YelloCakeDev successfully"
    if ! grep -Fxq "source ~/.YelloCakeDev" ~/.bashrc; then
        echo "source ~/.YelloCakeDev" >> ~/.bashrc
        echo "Added source to ~/.bashrc"
    fi
    if [ "$(basename "$SHELL")" != "bash" ]; then
        echo "Fuck you. You don't use bash."
    fi
else
    echo "Error downloading .YelloCakeDev"
fi
