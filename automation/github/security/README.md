# 📊 Dependabot Alerts Reporting Script

## 🚀 Overview

This script automates the process of fetching **Dependabot Alerts** for repositories in a GitHub organization. It:

- 📂 Scans all non-archived repositories in your GitHub organization.
- ⚠️ Identifies **high** and **critical** severity vulnerabilities reported by Dependabot.
- 📝 Generates two CSV reports:
  - **Dependabot Vulnerabilities Report**: Detailed information about high/critical alerts.
  - **Repositories Scanning Report**: Summary of repositories scanned and their alerts count.

## 🛠️ Prerequisites

Ensure you have the following before using the script:

- 🪪 A GitHub **Personal Access Token** (PAT) with the following permissions:
  - `read:org` (to access organization repositories)
  - `security_events` (to access Dependabot alerts)
- Python 3.6 or higher installed on your system.
- Required Python packages: `requests`.

## 📥 Installation

### MacOS
1. Install Python:
   ```bash
   brew install python
   ```
2. Install required packages:
   ```bash
   pip install requests
   ```

### Linux
1. Install Python (if not already installed):
   ```bash
   sudo apt update && sudo apt install python3 python3-pip -y
   ```
2. Install required packages:
   ```bash
   pip3 install requests
   ```

## 🛡️ Usage

### 1️⃣ Configuration
Before running the script, update the configuration:

- Replace `personal_access_token` with your **GitHub Personal Access Token**.
- Replace `organization_name` with the **name of your GitHub organization**.
- Optionally, update the output file names in `OUTPUT_FILE` and `REPOS_SCANNED_FILE`.

```python
GITHUB_TOKEN = "personal_access_token"  # Add GitHub user personal token here
ORG_NAME = "organization_name"  # Add your org name
OUTPUT_FILE = "dependabot_issues_report.csv"  # Change file name as required
REPOS_SCANNED_FILE = "repositories_list_scanned_for_dependabot_issues.csv"  # Change file name as required
```

### 2️⃣ Run the Script
Run the script using Python:

```bash
python3 dependabot_report.py
```

### 3️⃣ Output
After execution, two CSV files will be generated:

1. **`dependabot_issues_report.csv`**:
   - Contains detailed information about high/critical alerts.
2. **`repositories_list_scanned_for_dependabot_issues.csv`**:
   - Summarizes repositories scanned and their respective alerts count.

## 🌟 How This Script Helps at the Organizational Level

- **📉 Risk Reduction**: Identifies high-risk vulnerabilities across all repositories, enabling timely remediation.
- **⏱️ Time-Saving**: Automates manual scanning, making the process efficient and repeatable.
- **📊 Reporting**: Provides actionable insights through easy-to-read CSV reports.
- **🔍 Visibility**: Improves visibility into security vulnerabilities for decision-making.

## ✨ Features

- ✅ Scans all non-archived repositories in the organization.
- ✅ Filters and prioritizes high/critical severity alerts.
- ✅ Supports large organizations with pagination handling for GitHub API.
- ✅ Outputs comprehensive and structured CSV reports.

## 🧑‍💻 Contributing

Feel free to submit issues or suggest improvements by opening a pull request.

## 🔒 Security Notice

- Ensure your GitHub **Personal Access Token** is kept secure.
- Avoid committing sensitive information to version control.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

💡 *Made with ❤️ to secure your software ecosystem!*

