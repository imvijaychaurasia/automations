# 🚀 **Route53 Automation Suite**
This repository contains Python scripts designed to automate DNS record management and port scanning tasks. The suite is tailored to make AWS Route 53 management and network security analysis seamless and efficient.  

---

## 📜 **Table of Contents**  
1. [📦 Features](#features)  
2. [📂 Script Details](#script-details)  
   - [1️⃣ Export Route53 Records](#1-export-route53-records)  
   - [2️⃣ Port Scanning Automation](#2-port-scanning-automation)
   - [3️⃣ Analysis and Email Report](#3-analysis-and-email-report)
3. [🛠️ Modules Used](#modules-used)  
4. [✨ Benefits](#benefits)  
5. [📋 Usage](#usage)  

---

## 📝 **Features** <a name="features"></a>
✔️ Export A and CNAME records from AWS Route 53 in CSV format.  
✔️ Perform port scans on specified endpoints (via Route 53 DNS records).  
✔️ Analyze port status (`Open`, `Closed`) for critical services.  
✔️ Generate automated analysis reports and email them.

---

## 📂 **Script Details** <a name="script-details"></a>  

### 1️⃣ **Export Route53 Records** <a name="1-export-route53-records"></a>
🔍 **What it does**:  
This script fetches `A` and `CNAME` records from AWS Route 53 and saves them to a CSV file.

🛠 **Python Modules**:  
- `boto3`: For interacting with AWS APIs.
- `csv`: For CSV file handling.

📄 **Output File**:  
- `aws_route53_a-cname_records.csv` with columns: `Record, Type, Value`.  

---

### 2️⃣ **Port Scanning Automation** <a name="2-port-scanning-automation"></a>
🛡 **What it does**:  
Scans specified ports `443: HTTPS, 80: HTTP, 8080: HTTP-Alternative, 27017: MONGODB, 5432: POSTGRESQL, 3306: MySQL, 22: SSH, 21: FTP, 25: SMTP, 110: POP3, 143: IMAP, 445: SMB, 3389: RDP, SSL_Status, SSL_Info` for DNS records extracted from the `aws_route53_a-cname_records.csv` file.

🛠 **Python Modules**:  
- `socket`: For network communication.  
- `csv`: For handling input/output files.  
- `concurrent.futures`: For parallel scanning.

---

**🔒 SSL Certificate Check**:
This script includes a **robust SSL certificate check** to enhance your insights into the security status of your endpoints.

#### 🌟 **What it Does**
- **Validates SSL Certificates**: Checks whether the SSL certificate for a domain is active or expired.
- **Captures Expiration Dates**: Provides the expiration date of active SSL certificates.
- **Handles Errors Gracefully**: Logs any errors encountered during the SSL handshake.

---

#### 🛠 **How It Works**
1. **Port 443 Validation**: If port `443` (HTTPS) is open, the script attempts to establish an SSL connection.
2. **Certificate Retrieval**: Fetches the SSL certificate using Python's `ssl` module.
3. **Date Check**: Compares the certificate's expiration date against the current date.
4. **Results in Report**:
   - **`SSL_Status`**: Indicates whether the certificate is `Active`, `Expired`, or if an `Error` occurred.
   - **`SSL_Info`**: Includes the expiration date or details of the error.

---

#### 📊 **CSV Output**
The report includes the following SSL-related columns:

| **Column**     | **Description**                                              |
|----------------|--------------------------------------------------------------|
| `SSL_Status`   | Status of the SSL certificate (`Active`, `Expired`, `Error`) |
| `SSL_Info`     | Expiration date or error details                             |

---

#### ⚙️ **Dependencies**
- **Modules**:
  - `socket`: For creating TCP connections.
  - `ssl`: For retrieving and verifying SSL certificates.
  - `datetime`: To compare expiration dates.

---

#### 🎯 **Benefits**
- Proactively identify expired SSL certificates and ensure secure connections.
- Integrates seamlessly with the port scanning process, providing a comprehensive security overview.

📄 **Output File**:  
- `aaws_route53_a-cname_port_and_ssl_scan_results.csv` with columns:  
  `Record, HTTPS-443, HTTP-80, HTTP-Alternative-8080, MONGODB-27017, POSTGRESQL-5432, MySQL-3306, SSH-22, FTP-21, SMTP-25, POP3-110, IMAP-143, SMB-445, RDP-3389", SL_Status, SSL_Info`.  

---

### 3️⃣ **Analysis and Email Report <a name="3-analysis-and-email-report"></a>
📊 What it does:
Analyzes the `aws_route53_a-cname_port_and_ssl_scan_results.csv` file to generate a summary report, including:
- Total open/closed ports by type.
- Total endpoints with all ports closed.
- Total closed A and CNAME records.
📧 Sends the report via email to the specified recipient.

🛠 **Python Modules**:
- `csv`: For parsing CSV files.
- `smtplib`: For sending emails.
- `email.mime`: For constructing email content.
📄 Email Content:
- HTML-based report summarizing:

**Total endpoints**:
- Open/closed ports breakdown.
- Closed endpoint count.
- Closed DNS records count.

---

## 🛠️ **Modules Used** <a name="modules-used"></a>  

| Module            | Purpose                            | Installation Command           |  
|--------------------|------------------------------------|---------------------------------|  
| `boto3`           | AWS SDK for Python.               | `pip install boto3`            |  
| `socket`          | Networking module (built-in).     | (No installation required)     |  
| `csv`             | File handling for CSVs (built-in).| (No installation required)     |  
| `concurrent.futures` | For parallel execution.        | (No installation required)     |  


---

## 📋 **Usage** <a name="usage"></a>  

### Prerequisites  
- Python 3.7+  
- AWS CLI configured with a valid profile (`stage` in our case).  
- Necessary Python packages installed (`boto3`, etc.).  

---

### ⚙️ **Steps to Run**  

1️⃣ **Clone the Repository**:  
```bash
git clone https://github.com/imvjai/infosec-armor.git
cd infosec/aws_automations/route53
```

2️⃣ **Install Dependencies**:  
```bash
pip install boto3
```

3️⃣ **Run the Scripts**:  
- **Integrated Workflow**:  
   ```bash
   python aws_route53_a-cname_records_reportandscan.py
   ```
   Outputs:  
   - `aws_route53_a-cname_records.csv`  
   - `aws_route53_a-cname_port_and_ssl_scan_results.csv`  
- **Export Route53 Records**:  
   ```bash
   python aws_route53_a-cname_records_export.py
   ```
   Output: `aws_route53_a-cname_records.csv`

- **Port Scanning**:  
   ```bash
   python aws_route53_records_portscan.py
   ```
   Output: `aws_route53_a-cname_port_and_ssl_scan_results.csv`

---

## 🎯 **Scope of Automation**  
- 🚀 Efficiency: Automates tedious manual tasks like DNS record export and network port scanning.
- 🔒 Security: Quickly identify open ports and potential vulnerabilities.
- 📊 Data-Driven Insights: Export results in CSV format for easy analysis.
- 📧 Email Integration: Automatically delivers insights to stakeholders. 🌐 Scalable: Handles hundreds of DNS records effortlessly.
