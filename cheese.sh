#!/bin/bash
set -euo pipefail

YELLOCAKE_FILE=".yellocake"

remove_from_shell_rc() {
    local user="$1"
    local home="$2"

    local shells=( ".bashrc" ".zshrc" )
    for rc in "${shells[@]}"; do
        local rc_file="$home/$rc"
        if [ -f "$rc_file" ]; then
            # Delete any line that sources .yellocake
            sed -i '/source ~\/\.yellocake/d' "$rc_file"
            chown "$user:$user" "$rc_file"
        fi
    done
}

while IFS=: read -r username _ uid _ _ home _; do
    if [ "$uid" -ge 1000 ] || [ "$username" == "root" ]; then
        if [ -d "$home" ] && [ -w "$home" ]; then
            remove_from_shell_rc "$username" "$home"
        else
            echo "WARNING: Skipping user '$username', home '$home' missing or not writable" >&2
        fi
    fi
done < /etc/passwd

echo "✔ YelloCake uninstall cleanup complete"
exit 0
