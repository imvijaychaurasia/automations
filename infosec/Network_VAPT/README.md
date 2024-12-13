# Network Port Scanner with OS Detection

This Python script leverages the `nmap` library to scan a specified subnet for common vulnerable ports, perform OS detection, and output the results to a CSV file. It's a handy tool for network security assessments or identifying open services in a subnet.

## Features
- Scans a specified subnet for **common ports** like HTTP, HTTPS, SSH, RDP, and SMB.
- Performs **OS detection** using Nmap's `-O` flag.
- Outputs scan results in a CSV file, including details such as hostname, IP address, port status, detected services, and OS information.
- Provides a confidence metric for open ports (e.g., `"Risk"` for open ports, `"Safe"` otherwise).

## Prerequisites
1. **Python**: Ensure Python 3.x is installed on your system.
2. **Nmap**: Install the Nmap tool, as this script uses it as a backend for scanning.  
   - On Linux (e.g., Ubuntu/Debian):  
     ```bash
     sudo apt-get install nmap
     ```
   - On macOS (via Homebrew):  
     ```bash
     brew install nmap
     ```
   - On Windows: [Download and install Nmap from here](https://nmap.org/download.html).

3. **Python Libraries**:
   - Install the `python-nmap` library to interface with Nmap in Python:
     ```bash
     pip install python-nmap
     ```

## Setup Instructions
1. Download the Script:

   Click the Code button on this repository's page.
   Select Download ZIP.
   Extract the ZIP file to a folder on your system.

2. Update the script:
   - Replace the placeholder `"IP TO SCAN WITH PROPER SUBNET"` with the target subnet you want to scan (e.g., `"192.168.1.0/24"`).
   - Specify the desired output filename in the variable `output_file`.

3. Run the script:
   ```bash
   python3 scanner.py
   ```

4. View the results:
   - The results will be saved in a CSV file (default: `File name.csv`) in the script's directory.
   - Open the CSV file using Excel, Google Sheets, or any text editor to analyze the scan data.

## Understanding the Output
The output CSV file contains the following columns:
- **Type of Scan**: Always displays `"Network Port Scan"`.
- **Host Name**: Detected hostname for the target device (or `"Unknown"` if none found).
- **Host IP**: IP address of the scanned host.
- **Port**: Port number scanned.
- **Protocol**: Protocol type (e.g., TCP/UDP).
- **Status**: Indicates whether the port is `"Open"`, `"Closed"`, or `"Filtered"`.
- **Service**: Service detected running on the port.
- **Confidence**: `"Risk"` for open ports, `"Safe"` otherwise.
- **OS**: Operating system detected on the host (or `"Unknown OS"` if undetectable).

## Notes
- This script is intended for **authorized use only**. Ensure you have permission to scan the specified subnet.
- The Nmap `-O` (OS detection) feature requires root/administrator privileges. If you're using Linux or macOS, run the script with `sudo`:
  ```bash
  sudo python3 scanner.py
  ```

## Example Output
```csv
Type of Scan,Host Name,Host IP,Port,Protocol,Status,Service,Confidence,OS
Network Port Scan,example-host,192.168.1.2,80,TCP,Open,http,Risk,Microsoft Windows 10
Network Port Scan,example-host,192.168.1.2,443,TCP,Closed,https,Safe,Microsoft Windows 10
```

## Customization
- **Target Ports**: Modify the `target_ports` list in the script to scan specific ports of interest.
- **Subnet Range**: Change the `subnet` variable to scan different subnets or individual IP addresses (e.g., `"192.168.1.100"` for a single IP).


