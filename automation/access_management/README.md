# 🔐 GitHub Organization Users Management

[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com)
[![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)](https://www.python.org)
[![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white)](https://slack.com)

## 📋 Description

This project provides automation tools for managing and monitoring GitHub organization members. It fetches user details from your GitHub organization and sends notifications to Slack, helping maintain security and visibility of your organization's membership.

## 🚀 Features

- 📊 Lists all members of your GitHub organization
- 📧 Retrieves member details (username, name, email)
- 🔔 Automated Slack notifications
- 🔄 Easy to schedule and automate

## 🛠️ Prerequisites

- Python installed on your system
- GitHub Admin access token
- Slack webhook URL
- PyGithub library

## 📦 Installation

The bash script automatically handles the installation of required dependencies:

```bash
# PyGithub will be automatically installed if not present
pip install PyGithub --upgrade --user
```

## ⚙️ Configuration

1. Replace these variables in the scripts:
   - `org_admin_github_token`: Your GitHub admin access token
   - `orgname`: Your GitHub organization name
   - `SLACK_WEBHOOK_URL`: Your Slack webhook URL

2. Make the bash script executable:
```bash
chmod +x run_github_users.sh
```

## 🏃‍♂️ Usage

### Running manually:

```bash
./run_github_users.sh
```

### Automated scheduling:

Add to crontab for automated execution:
```bash
# Example: Run daily at 9 AM
0 9 * * * /path/to/run_github_users.sh
```

## 🔍 Output

The script outputs:
- GitHub username
- Full name
- Email address

Example Slack notification:
```
🚨 CRITICAL: These are the members of Orgname GitHub Organization:

username1 John Doe john@example.com
username2 Jane Smith jane@example.com
```

## 🔒 Security Considerations

- Keep your GitHub token secure
- Store the Slack webhook URL securely
- Regularly rotate access tokens
- Monitor script execution logs

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support, please contact your organization's GitHub administrators.

---
⭐️ Star this repository if you find it helpful!
