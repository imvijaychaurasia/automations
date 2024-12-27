# 📊 AWS IAM User Report Script

## 📜 Overview
This script automates the generation of a detailed AWS IAM user report. It extracts critical details such as user activity, permissions, policies, access keys, and console access status, and outputs the information in a CSV file for easy analysis.

## 🛠️ Prerequisites
Ensure the following requirements are met:
- **AWS CLI** installed and configured on your machine.
- Valid **AWS IAM credentials** with sufficient permissions to list IAM users and access user details.
- Basic knowledge of running shell scripts.

## 📥 Installation
### MacOS
1. Install the AWS CLI (if not already installed):
   ```bash
   brew install awscli
   ```
2. Make the script executable:
   ```bash
   chmod +x iam.sh
   ```

### Linux
1. Install the AWS CLI (if not already installed):
   ```bash
   sudo apt update && sudo apt install awscli -y
   ```
2. Make the script executable:
   ```bash
   chmod +x iam.sh
   ```

## 🔧 Configuration
1. Update the placeholders in the script:
   - Replace `YOUR_ACCESS_KEY_ID` with your AWS Access Key ID.
   - Replace `YOUR_SECRET_ACCESS_KEY` with your AWS Secret Access Key.
   - Replace `YOUR_AWS_REGION` with your AWS region (e.g., `us-west-2`).
2. (Optional) Ensure your IAM user or role has the following permissions:
   - `iam:ListUsers`
   - `iam:GetUser`
   - `iam:GetUserLastAccessedInfo`
   - `iam:ListAttachedUserPolicies`
   - `iam:ListAccessKeys`

## 🚀 Usage
1. Run the script:
   ```bash
   ./iam.sh
   ```
2. The script will:
   - Fetch details for all IAM users in the account.
   - Save the report as a CSV file with the naming convention `IAM_Report_<YYYY-MM-DD>.csv`.
   - Display the processing status for each user in the terminal.

### CSV Report Fields:
- **IAM User Name**: The username of the IAM user.
- **Last Activity**: The date of the user's last activity.
- **Permissions/Roles**: The roles or permissions associated with the user.
- **Attached Permission Policies**: The ARN of policies attached to the user.
- **Access Keys**: The list of access keys assigned to the user.
- **Created Date**: The creation date of the IAM user.
- **Last Console Sign-In**: The last date the user signed in to the AWS console.
- **Console Access Status**: Whether console access is enabled or disabled.
- **Active Access Key**: The ID of the user's active access key, if any.

## 🌟 How This Script Helps at the Organizational Level
- **🔒 Security Compliance**: Identifies inactive or over-permissioned IAM users for corrective actions.
- **📊 Detailed Auditing**: Provides a comprehensive view of IAM users' activity and permissions.
- **⏱️ Time-Saving**: Automates data collection and report generation, eliminating manual effort.
- **⚙️ Governance**: Facilitates adherence to AWS IAM best practices by providing actionable insights.

## 🔒 Security Notice
- Do not hardcode sensitive credentials in the script.
- Use AWS credentials through environment variables or a secure credential management system.
