import subprocess

# Route 53 script
def export_route53_records():
    subprocess.run(["python", "aws_route53_a-cname_records_export.py"])

# Port scan script
def run_port_scan():
    subprocess.run(["python", "aws_route53_records_portscan.py"])

# Analysis and Email
def run_analysis_and_email():
    subprocess.run(["python", "analysis_and_email.py"])

def main():
    print("Exporting Route 53 records...")
    export_route53_records()
    print("Route 53 export completed. Starting port scan...")
    run_port_scan()
    print("Port scan completed. Performing Analysis and Email reporting...")
    run_analysis_and_email()
    print("Analysis completed and report sent over the Email.")

if __name__ == "__main__":
    main()
