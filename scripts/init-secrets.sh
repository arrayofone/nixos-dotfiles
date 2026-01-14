#!/usr/bin/env bash
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables
HOST_NAME="${HOST_NAME:-$(hostname)}"
USER_NAME="${USER_NAME:-$(whoami)}"
SECRETS_DIR="secrets"
mkdir -p "$SECRETS_DIR"

echo -e "${YELLOW}Initializing Secrets Setup for Host: $HOST_NAME, User: $USER_NAME${NC}"

# Ensure sops is available
if ! command -v sops &> /dev/null; then
    echo -e "${RED}Error: sops is not installed or not in PATH.${NC}"
    exit 1
fi

# --- System Keys ---
echo -e "\n${GREEN}== System Keys ==${NC}"
SYSTEM_PUBLIC_KEY=""

if [[ "$(uname)" == "Darwin" ]]; then
    KEY_PATH="/etc/ssh/ssh_host_ed25519_key"
    AGE_DIR="/var/lib/sops-nix"
    AGE_KEY="$AGE_DIR/key.txt"

    # Generate SSH key if missing
    if [ ! -f "$KEY_PATH" ]; then
        echo "Generating system SSH key..."
        sudo ssh-keygen -t ed25519 -f "$KEY_PATH" -N ""
    else
        echo "System SSH key exists."
    fi

    # Generate Age key if missing
    if [ ! -f "$AGE_KEY" ]; then
        echo "Generating system Age key..."
        sudo mkdir -p "$AGE_DIR"
        # Read the ssh key with sudo, convert with nix run (user), write with sudo
        # Using nix run nixpkgs#ssh-to-age. This assumes nix is configured for user.
        sudo cat "$KEY_PATH" | nix run nixpkgs#ssh-to-age -- -private-key | sudo tee "$AGE_KEY" > /dev/null
    else
        echo "System Age key exists."
    fi
    
    # Get Public Key
    # Use 'age-keygen -y' on the private key.
    # We pipe the private key content to nix shell executing age-keygen
    SYSTEM_PUBLIC_KEY=$(sudo cat "$AGE_KEY" | nix shell nixpkgs#age -c age-keygen -y /dev/stdin)
    echo "System Public Key: $SYSTEM_PUBLIC_KEY"
else
    echo "Skipping System Keys (not Darwin/Local execution). Setup manually if remote."
    SYSTEM_PUBLIC_KEY=""
fi

# --- User Keys ---
echo -e "\n${GREEN}== User Keys ==${NC}"
USER_SSH_KEY="$HOME/.ssh/sops-nix"
USER_AGE_DIR="$HOME/.config/sops/age"
USER_AGE_KEY="$USER_AGE_DIR/keys.txt"

if [ ! -f "$USER_SSH_KEY" ]; then
    echo "Generating user SSH key ($USER_SSH_KEY)..."
    ssh-keygen -t ed25519 -f "$USER_SSH_KEY" -N ""
else
    echo "User SSH key exists."
fi

mkdir -p "$USER_AGE_DIR"
if [ ! -f "$USER_AGE_KEY" ]; then
    echo "Generating user Age key..."
    nix run nixpkgs#ssh-to-age -- -private-key -i "$USER_SSH_KEY" > "$USER_AGE_KEY"
else
    echo "User Age key exists."
fi

USER_PUBLIC_KEY=$(nix shell nixpkgs#age -c age-keygen -y "$USER_AGE_KEY")
echo "User Public Key: $USER_PUBLIC_KEY"

# --- Secrets Files Initialization ---
echo -e "\n${GREEN}== Secrets Files ==${NC}"

# Helper to init a file
init_secret_file() {
    local file=$1
    local keys=$2
    
    if [ ! -f "$file" ]; then
        echo "Creating and encrypting $file..."
        # Create a valid sops file with empty map
        # We pass the keys explicitly via --age so we don't depend on .sops.yaml yet
        echo "{}" | sops --encrypt --age "$keys" --filename "$file" /dev/stdin > "$file"
    else
        echo "$file already exists. Skipping creation."
    fi
}

KEYS_FOR_SYSTEM=""
if [ -n "$SYSTEM_PUBLIC_KEY" ]; then
    KEYS_FOR_SYSTEM="$SYSTEM_PUBLIC_KEY,$USER_PUBLIC_KEY"
else
    KEYS_FOR_SYSTEM="$USER_PUBLIC_KEY"
fi

HOST_SECRET="$SECRETS_DIR/$HOST_NAME.yaml"
USER_SECRET="$SECRETS_DIR/$USER_NAME.yaml"

# Init Host Secret (System + User keys)
if [ -n "$HOST_NAME" ]; then
    init_secret_file "$HOST_SECRET" "$KEYS_FOR_SYSTEM"
fi

# Init User Secret (User key only)
if [ -n "$USER_NAME" ]; then
    init_secret_file "$USER_SECRET" "$USER_PUBLIC_KEY"
fi

# --- Summary ---
echo -e "\n${GREEN}== Action Required ==${NC}"
echo "Add the following keys to your .sops.yaml:"
echo -e "${YELLOW}"
echo "keys:"
if [ -n "$SYSTEM_PUBLIC_KEY" ]; then
    echo "  - & $HOST_NAME $SYSTEM_PUBLIC_KEY"
fi
echo "  - & $USER_NAME $USER_PUBLIC_KEY"
echo -e "${NC}"
echo "And update the creation_rules in .sops.yaml to match these keys."
echo "Your secret files have been initialized and are ready for 'task secrets:edit:system' etc."