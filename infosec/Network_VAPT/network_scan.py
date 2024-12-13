import nmap
import csv

# Make the required changes below before executing
subnet = "195.168.1.0/22" #this is an of Local Subnet example
output_file = "Mumbai_networkscan_result.csv" #Output file name

# Define the ports to target
target_ports = [21, 22, 23, 25, 53, 80, 110, 139, 143, 445, 3389, 8080, 5357, 9100, 2049, 3306, 5432, 443]  # These are Common vulnerable ports

# Initialize the nmap scanner
nm = nmap.PortScanner()

# Perform the scan
print(f"Starting scan on subnet: {subnet}")
nm.scan(hosts=subnet, ports=",".join(map(str, target_ports)), arguments="-O")  # -O for OS detection

# Write the results to a CSV file
with open(output_file, mode="w", newline="") as csvfile:
    csv_writer = csv.writer(csvfile)
    # Write headers
    csv_writer.writerow(["Type of Scan", "Host Name", "Host IP", "Port", "Protocol", "Status", "Service", "Confidence", "OS"])

    for host in nm.all_hosts():
        hostname = nm[host].hostname() if nm[host].hostname() else "Unknown"
        host_ip = host
        os = nm[host]["osmatch"][0]["name"] if "osmatch" in nm[host] and nm[host]["osmatch"] else "Unknown OS"

        for proto in nm[host].all_protocols():
            for port in nm[host][proto].keys():
                port_state = nm[host][proto][port]["state"]
                service = nm[host][proto][port]["name"]
                confidence = "Risk" if port_state == "open" else "Safe"

                # Write each row
                csv_writer.writerow([
                    "Network Port Scan",
                    hostname,
                    host_ip,
                    port,
                    proto.upper(),
                    port_state.capitalize(),
                    service,
                    confidence,
                    os
                ])

print(f"Scan complete. Results saved in {output_file}")
