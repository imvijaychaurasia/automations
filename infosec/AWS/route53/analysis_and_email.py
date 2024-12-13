import csv
from collections import Counter
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Source Files
route53_file = "aws_route53_a-cname_records.csv"
port_scan_file = "aws_route53_a-cname_port_and_ssl_scan_results.csv"

# Email details
smtp_server = "smtp.gmail.com"
smtp_port = 587
sender_email = "xyz@xyz.com" #sender email id
sender_password = "password" #change the password
recipient_email = "abc@xyz.com, def@xyz.com"

# Function to generate the analysis report
def generate_analysis_report():
    total_open_ports = Counter()
    total_closed_ports = Counter()
    closed_endpoints = 0
    total_records = 0

    # Analyze port scan results
    with open(port_scan_file, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            total_records += 1
            endpoint_closed = True
            for port, status in row.items():
                if port.startswith("Port"):
                    if status == "Open":
                        total_open_ports[port] += 1
                        endpoint_closed = False
                    elif status == "Closed":
                        total_closed_ports[port] += 1
            if endpoint_closed:
                closed_endpoints += 1

    # Analyze Route53 records for closed ports
    closed_records_count = 0
    with open(route53_file, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            record_type = row["Type"]
            if record_type in {"A", "CNAME"}:
                closed_records_count += 1

    return {
        "total_open_ports": total_open_ports,
        "total_closed_ports": total_closed_ports,
        "closed_endpoints": closed_endpoints,
        "closed_records_count": closed_records_count,
        "total_records": total_records,
    }

# Function to send email
def send_email(report):
    # Prepare email content
    subject = "Port Scan Analysis Report"
    body = f"""
    <html>
    <body>
        <h2>Port Scan Analysis Report</h2>
        <p><strong>Total Endpoints:</strong> {report['total_records']}</p>
        <h3>Port Status:</h3>
        <ul>
            <li><strong>Open Ports:</strong></li>
            <ul>
                {"".join([f"<li>{port}: {count}</li>" for port, count in report['total_open_ports'].items()])}
            </ul>
            <li><strong>Closed Ports:</strong></li>
            <ul>
                {"".join([f"<li>{port}: {count}</li>" for port, count in report['total_closed_ports'].items()])}
            </ul>
        </ul>
        <p><strong>Total Endpoints with All Ports Closed:</strong> {report['closed_endpoints']}</p>
        <p><strong>Total Closed A and CNAME Records:</strong> {report['closed_records_count']}</p>
    </body>
    </html>
    """

    # Setup email
    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = sender_email
    msg["To"] = recipient_email
    msg.attach(MIMEText(body, "html"))

    # Send email
    try:
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()  # Secure the connection
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, recipient_email, msg.as_string())
        print(f"Email sent to {recipient_email} successfully!")
    except Exception as e:
        print(f"Failed to send email: {e}")

# Main function
def main():
    print("Generating analysis report...")
    report = generate_analysis_report()
    print("Analysis report generated successfully. Sending email...")
    send_email(report)

if __name__ == "__main__":
    main()
