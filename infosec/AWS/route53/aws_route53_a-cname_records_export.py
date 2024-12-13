import boto3
import csv

# AWS profile and output file
aws_profile = "test" ##change aws profile name
output_file = "aws_route53_a-cname_records.csv"

# Set up the boto3 session
boto3.setup_default_session(profile_name=aws_profile)
route53 = boto3.client('route53')

# Fetch all hosted zones
def get_hosted_zones():
    response = route53.list_hosted_zones()
    return response['HostedZones']

# Fetch A and CNAME records for a hosted zone
def get_a_cname_records(zone_id):
    records = []
    paginator = route53.get_paginator('list_resource_record_sets')
    for page in paginator.paginate(HostedZoneId=zone_id):
        for record in page['ResourceRecordSets']:
            if record['Type'] in ['A', 'CNAME']:
                for value in record.get('ResourceRecords', []):
                    records.append({
                        'Record': record['Name'].strip('.'),
                        'Type': record['Type'],
                        'Value': value['Value']
                    })
    return records

# Write records to CSV
def write_to_csv(records):
    with open(output_file, 'w', newline='') as csvfile:
        fieldnames = ['Record', 'Type', 'Value']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(records)

    print(f"Records saved to {output_file}")

# Main function
def main():
    all_records = []
    hosted_zones = get_hosted_zones()

    print(f"Found {len(hosted_zones)} hosted zones.")
    for zone in hosted_zones:
        print(f"Processing hosted zone: {zone['Name']}")
        zone_id = zone['Id'].split('/')[-1]  # Extract the Zone ID
        records = get_a_cname_records(zone_id)
        all_records.extend(records)

    if all_records:
        write_to_csv(all_records)
    else:
        print("No A or CNAME records found.")

if __name__ == "__main__":
    main()
