from google.oauth2 import service_account
from googleapiclient.discovery import build
import pandas as pd
import subprocess
import re

def get_credentials():
    """
    Get credentials from service account key file.
    """
    SCOPES = [
        'https://www.googleapis.com/auth/drive.readonly'
    ]
    
    credentials = service_account.Credentials.from_service_account_file(
        '/adbfds.json',  # Path to the JSON file
        scopes=SCOPES,
        subject='abcd@xyz.com'  # Google Workspace Super-Admin Email id
    )
    return credentials

def list_shared_files(drive_service):
    """
    List all files in Google Drive and check if they are shared externally.
    """
    results = []
    page_token = None
    
    # Define supported MIME types
    file_types = [
        'application/vnd.google-apps.folder', 'application/vnd.google-apps.document', 
        'application/vnd.google-apps.spreadsheet', 'application/vnd.google-apps.presentation', 
        'application/vnd.google-apps.shortcut', 'application/vnd.google-apps.form', 
        'image/png', 'image/jpeg', 'image/jpg', 'image/svg+xml', 'application/pdf', 
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 
        'application/vnd.ms-excel', 'application/vnd.ms-powerpoint', 
        'application/vnd.adobe.photoshop', 'application/vnd.google-apps.video', 
        'audio/mpeg', 'audio/wav', 'text/plain', 'application/zip', 
        'application/x-zip-compressed', 'application/x-rar-compressed', 
        'application/x-tar', 'application/x-msdownload', 'application/x-apple-diskimage'
    ]

    # Compile the regex pattern to check for internal file owners
    internal_domain_pattern = re.compile(r'@(xyz\.com|bzlnks\.com|xyz\.in)$') ##update your internal domain

    while True:
        try:
            # List files with their permissions, filtered by supported MIME types
            files = drive_service.files().list(
                q=" or ".join([f"mimeType='{mime}'" for mime in file_types]),
                fields="nextPageToken, files(id, name, mimeType, webViewLink, owners, permissions, createdTime)",
                pageToken=page_token,
                includeItemsFromAllDrives=True,
                supportsAllDrives=True
            ).execute()
            
            for file in files.get('files', []):
                # Include files only if the owner has an internal domain
                file_owners = [owner.get('emailAddress') for owner in file.get('owners', [])]
                if not any(internal_domain_pattern.search(email) for email in file_owners):
                    continue  # Skip this file if none of the owners match internal domains
                
                # Basic file information
                file_info = {
                    'File_ID': file.get('id'),
                    'File_Name': file.get('name'),
                    'File_Type': file.get('mimeType').split('.')[-1],  # Extracts type from MIME type
                    'File_Link': file.get('webViewLink'),
                    'File_Creation_Date': file.get('createdTime'),
                    'File_Owner': ', '.join(file_owners)
                }
                
                # Check permissions for external sharing
                external_shares = []
                for permission in file.get('permissions', []):
                    email = permission.get('emailAddress')
                    if email and not email.endswith(('@xyz.com', '@bzlnks.com', '@zyx.in')):  # Exclude internal recipients
                        external_shares.append({
                            'Recipient': email,
                            'Access_Type': permission.get('role')
                        })
                
                # Append data only if there's external sharing
                if external_shares:
                    for share in external_shares:
                        results.append({
                            **file_info,
                            'Recipient': share['Recipient'],
                            'Type_of_Access': share['Access_Type']
                        })
            
            # Pagination
            page_token = files.get('nextPageToken')
            if not page_token:
                break
                
        except Exception as e:
            print(f"Error fetching files: {e}")
            break
    
    return results

def export_report(shared_files_data):
    """
    Export the shared files data to a CSV file.
    """
    if shared_files_data:
        df = pd.DataFrame(shared_files_data)
        
        # Sort by creation date
        df['File_Creation_Date'] = pd.to_datetime(df['File_Creation_Date'])
        df = df.sort_values('File_Creation_Date', ascending=False)
        
        # Format dates for better readability
        df['File_Creation_Date'] = df['File_Creation_Date'].dt.strftime('%Y-%m-%d %H:%M:%S')
        
        # Export to CSV
        filename = '/Users/vijay/Documents/gw_external_sharing_report_all_files.csv'  # Adjust path as needed
        df.to_csv(filename, index=False, encoding='utf-8')
        print(f"\nReport exported successfully to {filename}")
        print(f"Total records: {len(df)}")
        
        # Print summary
        print("\nSummary:")
        print(f"Total unique files shared: {df['File_ID'].nunique()}")
        print(f"Total unique recipients: {df['Recipient'].nunique()}")
        print("\nBreakdown by document type:")
        print(df['File_Type'].value_counts())
        return filename
    else:
        print("No externally shared files found.")
        return None

def trigger_email_analysis():
    """
    Trigger the email analysis script.
    """
    try:
        subprocess.run(['python3', 'report_analysis.py'], check=True)
        print("Report analysis triggered successfully.")
    except Exception as e:
        print(f"Error triggering report analysis: {e}")

def main():
    # Initialize credentials and Drive service
    credentials = get_credentials()
    drive_service = build('drive', 'v3', credentials=credentials)
    
    print("Collecting all externally shared files...")
    shared_files_data = list_shared_files(drive_service)
    
    # Export report and trigger email analysis
    report_file = export_report(shared_files_data)
    if report_file:
        trigger_email_analysis()

if __name__ == '__main__':
    main()
