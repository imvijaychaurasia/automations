import socket
import ssl
import csv
import os
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor

# File paths
route53_file = "aws_route53_a-cname_records.csv"
output_file = "aws_route53_a-cname_port_and_ssl_scan_results.csv"

# Ports to scan with descriptive headers
ports = {
    443: "HTTPS-443",
    80: "HTTP-80",
    8080: "HTTP-Alternative-8080",
    27017: "MONGODB-27017",
    5432: "POSTGRESQL-5432",
    3306: "MySQL-3306",
    22: "SSH-22",
    21: "FTP-21",
    25: "SMTP-25",
    110: "POP3-110",
    143: "IMAP-143",
    445: "SMB-445",
    3389: "RDP-3389",
}

# Timeout for socket connection
timeout = 2

# SSL certificate check function
def check_ssl_certificate(hostname):
    try:
        context = ssl.create_default_context()
        with socket.create_connection((hostname, 443), timeout=timeout) as sock:
            with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                cert = ssock.getpeercert()
                expiry_date = datetime.strptime(cert["notAfter"], "%b %d %H:%M:%S %Y %Z")
                if expiry_date < datetime.utcnow():
                    return "Expired", expiry_date.strftime("%d-%m-%Y")
                else:
                    return "Active", expiry_date.strftime("%d-%m-%Y")
    except Exception as e:
        return "Error", str(e)

# Port scanning function
def scan_ports(hostname):
    results = {"Record": hostname}
    for port, name in ports.items():
        try:
            with socket.create_connection((hostname, port), timeout=timeout):
                results[name] = "Open"
        except:
            results[name] = "Closed"

    # Add SSL certificate check for HTTPS (port 443)
    if "HTTPS" in results and results["HTTPS"] == "Open":
        ssl_status, ssl_info = check_ssl_certificate(hostname)
        results["SSL_Status"] = ssl_status
        results["SSL_Info"] = ssl_info
    else:
        results["SSL_Status"] = "N/A"
        results["SSL_Info"] = "No SSL (Port Closed)"
    
    return results

# Function to read records and scan ports
def perform_port_scan(input_file, output_file):
    records = []

    # Read input file
    with open(input_file, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            records.append(row["Record"])

    # Perform scanning in parallel
    results = []
    with ThreadPoolExecutor(max_workers=10) as executor:
        for result in executor.map(scan_ports, records):
            results.append(result)

    # Write output to CSV
    with open(output_file, "w", newline="") as file:
        fieldnames = ["Record"] + list(ports.values()) + ["SSL_Status", "SSL_Info"]
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(results)

    print(f"Port scan and SSL certificate check completed. Results saved to {output_file}.")

# Main function
if __name__ == "__main__":
    perform_port_scan(route53_file, output_file)
