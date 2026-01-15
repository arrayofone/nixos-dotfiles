#!/usr/bin/env bash
set -e

# Usage: ./manage-secrets.sh <action> <scope>
# action: edit, encrypt, decrypt
# scope: system, user

ACTION=$1
SCOPE=$2

if [ -z "$ACTION" ] || [ -z "$SCOPE" ]; then
    echo "Usage: $0 <action> <scope>"
    echo "  action: edit, encrypt, decrypt"
    echo "  scope: system, user"
    exit 1
fi

HOST_NAME=$(hostname)
USER_NAME=$(whoami)
SECRETS_DIR="secrets"
USER_AGE_KEY="/Users/$USER_NAME/.config/sops/age/keys.txt"
SYSTEM_AGE_KEY="/var/lib/sops-nix/key.txt"

if [ "$SCOPE" == "system" ]; then
    TARGET_FILE="$SECRETS_DIR/$HOST_NAME.yaml"
elif [ "$SCOPE" == "user" ]; then
    TARGET_FILE="$SECRETS_DIR/$USER_NAME.yaml"
else
    echo "Error: Scope must be 'system' or 'user'"
    exit 1
fi

if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: Secrets file '$TARGET_FILE' does not exist."
    echo "Run 'task secrets:init' to initialize it."
    exit 1
fi

# Function to execute sops with fallback to sudo/system key
execute_sops() {
    local sops_bin
    sops_bin=$(command -v sops)

    # Try as user first
    if SOPS_AGE_KEY_FILE="$USER_AGE_KEY" "$sops_bin" "$@"; then
        return 0
    fi

    # If failed and scope is system, try with system key via sudo
    if [ "$SCOPE" == "system" ]; then
        echo "User access failed. Attempting with system key (requires sudo)..." >&2

        if [ ! -f "$SYSTEM_AGE_KEY" ]; then
            echo "System age key not found at $SYSTEM_AGE_KEY. Cannot fallback." >&2
            return 1
        fi

        # Use sudo with the absolute path to sops and the key environment variable
        sudo SOPS_AGE_KEY_FILE="$SYSTEM_AGE_KEY" "$sops_bin" "$@"
        return $?
    fi

    return 1
}

case $ACTION in
    edit)
        echo "Editing $TARGET_FILE..."
        execute_sops "$TARGET_FILE"
        ;;
    encrypt)
        echo "Encrypting (in-place) $TARGET_FILE..."
        if [ ! -f ".sops.yaml" ]; then
            echo "Error: .sops.yaml not found. Cannot encrypt correctly."
            exit 1
        fi
        execute_sops -e -i "$TARGET_FILE"
        ;;
    decrypt)
        echo "Decrypting (in-place) $TARGET_FILE..."
        execute_sops -d -i "$TARGET_FILE"
        ;;
    *)
        echo "Error: Action must be 'edit', 'encrypt', or 'decrypt'"
        exit 1
        ;;
esac
