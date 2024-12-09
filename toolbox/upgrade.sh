#!/bin/bash

# ===== Script Overview =====
# This script automates the upgrade process for the Pellcore blockchain node.
# 
# Workflow:
# 1. Configuration Setup
#    - Sets daemon home directory, chain ID, and validator key name
#    - Defines upgrade proposal ID and binary download URL
#
# 2. Validator Status Check
#    - Determines if the current node is a validator
#    - Uses pellcored keys and staking query commands
#
# 3. Upgrade Preparation
#    - Creates required directory structure under .pellcored/upgrades
#    - Downloads new binary from specified URL
#    - Verifies binary functionality
#
# 4. Governance Participation
#    - For validator nodes only: submits 'yes' vote for upgrade proposal
#    - Skips voting for non-validator nodes
#
# 5. Final Steps
#    - Completes upgrade preparation
#    - Reminds about Cosmovisor requirement

# Configuration parameters
DAEMON_HOME=$HOME/.pellcored/cosmovisor
CHAIN_ID="ignite_186-1"
KEY_NAME="operator"  # validator operator key name

PROPOSAL_ID="3"  # upgrade proposal ID
UPGRADE_NAME="v1.0.20" # upgrade name matching the governance proposal
BINARY_URL="https://github.com/0xPellNetwork/network-config/releases/download/v1.0.20-ignite/pellcored-v1.0.20-linux-amd64"  # binary download URL


# Check if node is a validator
check_validator() {
    local validator_address=$(pellcored keys show $KEY_NAME --bech val -a)
    local validator_status=$(pellcored query staking validator $validator_address --output json 2>/dev/null)

    if [ $? -eq 0 ]; then
        echo "This is a validator node"
        return 0
    else
        echo "This is not a validator node"
        return 1
    fi
}

# Create upgrade directory structure
create_upgrade_dir() {
    echo "Creating upgrade directory structure..."
    mkdir -p $DAEMON_HOME/upgrades/$UPGRADE_NAME/bin
}

# Download and verify new binary
download_binary() {
    echo "Downloading new binary..."
    wget $BINARY_URL -O $DAEMON_HOME/upgrades/$UPGRADE_NAME/bin/pellcored
    chmod +x $DAEMON_HOME/upgrades/$UPGRADE_NAME/bin/pellcored
    
    # Verify binary
    if ! $DAEMON_HOME/upgrades/$UPGRADE_NAME/bin/pellcored version; then
        echo "Binary verification failed!"
        exit 1
    fi
}

# Vote for upgrade proposal
vote_proposal() {
    echo "Voting for upgrade proposal..."
    pellcored tx gov vote $PROPOSAL_ID yes \
        --from $KEY_NAME \
        --chain-id $CHAIN_ID \
        --fees=0.6pell \
        --gas=60000000 \
        --keyring-backend=test \
        -y
}

# Ask for voting confirmation
confirm_voting() {
    echo -e "\033[1;33m⚠️  IMPORTANT\033[0m"
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    read -p $'\033[1;34m🔷 Do you want to proceed with validator check and voting? (y/N): \033[0m' response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Main function
main() {
    # Create upgrade directory
    create_upgrade_dir

    # Download binary
    download_binary

    # Ask for confirmation before checking validator and voting
    if confirm_voting; then
        # Check if validator and vote
        if check_validator; then
            echo "Validator node detected, proceeding with voting..."
            vote_proposal
        else
            echo "Non-validator node, skipping voting..."
        fi
    else
        echo "Skipping validator check and voting..."
    fi

    # Final success messages with decorative elements
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;32m🎉 Upgrade preparation completed successfully! ✨\033[0m"
    echo -e "\033[1;32m🤖 Please ensure Cosmovisor is running and monitoring for the upgrade 🔄\033[0m"
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}

# Execute main function
main