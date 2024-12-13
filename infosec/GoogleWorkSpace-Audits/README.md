# 📊 External Sharing Report for Google Drive Files

> A script to **audit and report external file sharing** on Google Drive, helping secure data by identifying files shared outside the organization.

---

### 📝 **What Does This Script Do?**

This script checks Google Drive for files shared with external users and generates a detailed report in CSV format. It identifies various file types, including:
- **Documents** (Google Docs, Word)
- **Spreadsheets** (Google Sheets, Excel)
- **Images** (PNG, JPEG, SVG)
- **Media** (Video, Audio)
- **Compressed Files** (ZIP, TAR, RAR)
- **Other Files** (PDF, Text, Photoshop, Shortcuts)

Use case: **Security and compliance auditing** to ensure that sensitive files aren't accidentally or maliciously shared with external parties.

---

### 🧹 **Remove External Recipients from Shared Files Script**

This additional script helps **remove external recipients** from files that were previously shared externally. It works in conjunction with the external sharing report to:
- Identify files with external recipients based on the `file_id` in the report.
- Remove external sharing for files that belong to non-allowed domains.
  
#### **What Does This Script Do?**
- Reads the **`gw_external_sharing_report_all_files.csv`** to identify files shared with external users.
- Excludes specific domains (e.g., `xyz.com`, `abc.in`, `hig.com`).
- Removes sharing for users belonging to external domains not included in the allowed list.
- Ensures that only approved domains can have access to sensitive files.

This is critical for **data protection** and ensuring that sensitive company data does not get shared inadvertently with unauthorized external parties.

---

### ⚙️ **Pre-requisites**

To use this script, you’ll need:
1. **Python 3** installed
2. **Google Cloud Project** setup with Drive API access
3. **Service account JSON file** and **Google Workspace super admin email ID**
4. **Update file paths in the script** # Path to JSON file and CSV export

---

### 🔑 **Google Project APIs and Required Scopes**

Ensure the following APIs and permissions are enabled in the Google Cloud project:

| API               | Purpose                         | Scope                                  |
|-------------------|---------------------------------|----------------------------------------|
| Google Drive API  | Access Google Drive files       | `https://www.googleapis.com/auth/drive.readonly` |

You can enable the Google Drive API in the **Google Cloud Console**.

---

### 🔐 **Required JSON File and Admin Email**
- **Service Account JSON**: This file contains credentials for accessing the Google Drive API.
  - Download it from Google Cloud Console and save it in a secure location.
- **Admin Email**: A Google Workspace super admin email for impersonation, allowing the script to access shared drives across the organization.

---

### 🖥️ **Installation (Mac & Linux)**

1. **Clone this repository**:
   ```bash
   git clone https://github.com/imvjai/infosec-armor.git
   cd infosec/GoogleWorkSpace-Audits/documents-files
