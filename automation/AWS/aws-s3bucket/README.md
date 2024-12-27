# 🚀 AWS S3 Bucket Public Access Blocking Script

## 📜 Overview
This script automates the process of enabling **"Block All Public Access"** for specified AWS S3 buckets in a production environment. It ensures compliance with security standards and notifies via Slack upon successful execution.

## 🛠️ Prerequisites
Before using this script, ensure you have:
- **AWS CLI** installed and configured on your machine.
- A **Slack webhook URL** for notifications.
- A file named `prod_s3bucket_block_publicaccess.txt` containing the list of S3 bucket names (one per line).

## 📥 Installation
### MacOS
1. Install the AWS CLI (if not already installed):
   ```bash
   brew install awscli
   ```
2. Make the script executable:
   ```bash
   chmod +x block_s3_public_access.sh
   ```

### Linux
1. Install the AWS CLI (if not already installed):
   ```bash
   sudo apt update && sudo apt install awscli -y
   ```
2. Make the script executable:
   ```bash
   chmod +x block_s3_public_access.sh
   ```

## 🔧 Configuration
1. Replace the placeholders in the script:
   - `<key>`: Your AWS Access Key ID.
   - `<secrete>`: Your AWS Secret Access Key.
   - `<slack_webhook>`: Your Slack webhook URL for notifications.
2. Create a file named `prod_s3bucket_block_publicaccess.txt` containing the list of S3 bucket names. Example:
   ```
   my-bucket-1
   my-bucket-2
   my-bucket-3
   ```

## 🚀 Usage
1. Run the script:
   ```bash
   ./block_s3_public_access.sh
   ```
2. The script will:
   - Read bucket names from `prod_s3bucket_block_publicaccess.txt`.
   - Enable **"Block All Public Access"** for each bucket.
   - Notify a specified Slack channel with a summary of the operation.

## 🛡️ Security and Compliance Benefits
- **🔒 Improved Security**: Ensures no S3 buckets are publicly accessible, reducing the risk of data exposure.
- **📊 Auditing**: Provides real-time notifications via Slack for tracking changes and compliance.
- **⏱️ Time-Saving**: Automates the process of blocking public access for multiple buckets.
