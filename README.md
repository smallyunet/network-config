# 🌐 Pell network-config

This repository contains all configuration parameters for the Pell Network.

## 📂 Directory Structure

### 🗂️ Node Configuration Files

- `app.toml` - Application configuration for nodes
- `client.toml` - Client configuration settings
- `config.toml` - Core node configuration parameters
- `genesis.json` - Network Genesis file

### 🌐 Network Services

- `rpc_node` - Public RPC node information for Pell Network
  - Endpoints
  - Rate limits
  - Supported APIs
- `state_sync_node` - Public State Sync node information for Pell Network
  - Snapshot intervals
  - Retention policy
  - Connection details

### 📄 Contract Information

- `system_contract` - System contract addresses for Pell Network
  - Contract addresses
  - ABI specifications
  - Deployment information

## 🔧 Usage

1. Clone this repository
2. Copy the configuration files to your node's config directory
3. Update the necessary parameters according to your node type
4. Restart your node to apply changes

## 📝 Description

This repository serves as a centralized configuration management center for Pell Network, storing all network-related configuration information. By managing these configurations in a unified way, we can better maintain network consistency and reliability.
