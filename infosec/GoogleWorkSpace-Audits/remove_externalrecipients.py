import csv
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# Configuration
SERVICE_ACCOUNT_FILE = '/path/to/file/infosec-extrnlfileshare-report-7537d0da1323.json'  # Path to service account JSON file
SCOPES = ['https://www.googleapis.com/auth/drive']
SUPER_ADMIN_EMAIL = '@xyz.com'  # Google Workspace Super-Admin Email

# List of allowed domains for external sharing
ALLOWED_DOMAINS = ["xyz.com", "xyz.com", "xyz.in", "xyz.com", "xyz.com"] ##update allowed domains details

# Authenticate and create the Google Drive API client
def create_drive_service():
    credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE,
        scopes=SCOPES,
        subject=SUPER_ADMIN_EMAIL  # Impersonate super admin
    )
    return build('drive', 'v3', credentials=credentials)

# Check if the domain is in the allowed list
def is_domain_allowed(email):
    domain = email.split('@')[-1].lower()
    return domain in ALLOWED_DOMAINS

# Remove external sharing permissions from a file
def remove_external_permissions(file_id, drive_service):
    try:
        # Get all permissions for the file
        permissions = drive_service.permissions().list(fileId=file_id, fields="permissions(id, emailAddress)").execute()
        for permission in permissions.get("permissions", []):
            email = permission.get("emailAddress", "")
            if email and not is_domain_allowed(email):  # Only remove if email is not in allowed domains
                permission_id = permission['id']
                try:
                    drive_service.permissions().delete(fileId=file_id, permissionId=permission_id).execute()
                    print(f"Removed permission for {email} on file {file_id}")
                except HttpError as e:
                    print(f"Could not remove permission for {email} on file {file_id}: {e}")
    except HttpError as e:
        print(f"Error accessing permissions for file {file_id}: {e}")

# Process CSV and remove external permissions from listed files
def process_file_sharing_report(csv_file, drive_service):
    with open(csv_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            file_id = row['file_id']
            print(f"Processing file ID: {file_id}")
            remove_external_permissions(file_id, drive_service)

# Main function
def main():
    drive_service = create_drive_service()
    report_file = 'gw_external_sharing_report_all_files.csv'  # Path to the exported CSV report file
    process_file_sharing_report(report_file, drive_service)

if __name__ == "__main__":
    main()
