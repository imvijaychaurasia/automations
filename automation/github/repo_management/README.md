# 📂 GitHub Repository Management Scripts

## 📜 Overview
This repository contains automation scripts for managing GitHub repositories within an organization. These scripts simplify repetitive tasks such as archiving, unarchiving, and tracking public repositories.

### Scripts Included:
1. **`archive_repos.sh`**: Archives repositories listed in a file and sends Slack notifications.
2. **`unarchive_repo.sh`**: Unarchives repositories listed in a file and notifies via Slack.
3. **`unarchive_public_repos.sh`**: Lists all unarchived public repositories in the organization and reports them to a Slack channel.

## 🛠️ Prerequisites
Ensure the following before using these scripts:
- A GitHub **Personal Access Token (PAT)** with the `repo` scope.
- A **Slack Webhook URL** for sending notifications.
- Basic knowledge of running shell scripts.

## 📥 Installation
### MacOS
1. Install `curl` (if not already installed):
   ```bash
   brew install curl
   ```
2. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```

### Linux
1. Install `curl` (if not already installed):
   ```bash
   sudo apt update && sudo apt install curl -y
   ```
2. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```

## 🔧 Configuration
Before running any script, update the following placeholders in the script files:
- `<your-access-token>`: Your GitHub Personal Access Token.
- `<org>`: The name of your GitHub organization.
- `<slack-webhook-url>`: Your Slack Webhook URL.

### Additional Configuration for `archive_repos.sh` and `unarchive_repo.sh`
- **Repository List File**: Create a text file (e.g., `repository_list.txt`) containing the names of repositories, one per line.

## 🚀 Usage
### 1️⃣ Archiving Repositories (`archive_repos.sh`)
1. Ensure `repository_list.txt` contains the names of repositories to be archived.
2. Run the script:
   ```bash
   ./archive_repos.sh
   ```
3. Output:
   - Repositories listed in `repository_list.txt` will be archived.
   - Notifications will be sent to the configured Slack channel.

### 2️⃣ Unarchiving Repositories (`unarchive_repo.sh`)
1. Ensure `repository_list.txt` contains the names of repositories to be unarchived.
2. Run the script:
   ```bash
   ./unarchive_repo.sh
   ```
3. Output:
   - Repositories listed in `repository_list.txt` will be unarchived.
   - Notifications will be sent to the configured Slack channel.

### 3️⃣ Listing Unarchived Public Repositories (`unarchive_public_repos.sh`)
1. Run the script:
   ```bash
   ./unarchive_public_repos.sh
   ```
2. Output:
   - A Slack notification listing all unarchived public repositories in the organization.

## 🌟 How These Scripts Help at the Organizational Level
- **📉 Risk Management**: Helps control and monitor the status of public and private repositories.
- **⏱️ Time-Saving**: Automates repository management tasks, reducing manual effort.
- **📊 Transparency**: Provides real-time Slack notifications for organizational visibility.
- **🔒 Compliance**: Ensures repositories are archived or unarchived as per organizational policies.

## 🔒 Security Notice
- Keep your GitHub **Personal Access Token** and Slack Webhook URL secure.
- Avoid committing sensitive data to version control.
