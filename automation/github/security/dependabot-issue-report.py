import requests
import csv
from datetime import datetime
import urllib3
import warnings

# Configuration
GITHUB_TOKEN = "personal_access_token" ##add github user personal token here
ORG_NAME = "organization_name" ##add your org name
OUTPUT_FILE = "dependabot_issues_report.csv" ##change file name as required
REPOS_SCANNED_FILE = "repositories_list_scanned_for_dependabot_issues.csv" ##change file name as required

# Headers for GitHub API requests
headers = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github.v3+json"
}

def get_org_repositories():
    """Get all non-archived repositories from the organization."""
    repos = []
    page = 1
    
    while True:
        url = f"https://api.github.com/orgs/{ORG_NAME}/repos?page={page}&per_page=100"
        response = requests.get(url, headers=headers)
        
        if response.status_code != 200:
            print(f"Error fetching repositories: {response.status_code}")
            print(f"Response: {response.text}")
            break
            
        data = response.json()
        if not data:
            break
            
        # Filter out archived repositories
        filtered_repos = [
            repo for repo in data
            if not repo.get('archived', False)
        ]
        
        repos.extend(filtered_repos)
        page += 1
    
    return repos

def get_dependabot_alerts(repo_name):
    """Get high and critical severity Dependabot alerts for a repository."""
    alerts = []
    page = 1
    
    while True:
        url = f"https://api.github.com/repos/{ORG_NAME}/{repo_name}/dependabot/alerts?state=open&page={page}&per_page=100"
        response = requests.get(url, headers=headers)
        
        if response.status_code != 200:
            print(f"No alerts or access denied for {repo_name}")
            break
            
        data = response.json()
        if not data:
            break
            
        # Filter alerts based on severity
        filtered_alerts = [
            alert for alert in data
            if alert.get('security_advisory', {}).get('severity', '').upper() in ['CRITICAL', 'HIGH']
        ]
        
        alerts.extend(filtered_alerts)
        page += 1
    
    return alerts

def write_repositories_report(repos, alerts_count):
    """Write the repositories scanning report."""
    with open(REPOS_SCANNED_FILE, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([
            'Repository',
            'Visibility',
            'Last Updated',
            'Description',
            'High/Critical Alerts Count',
            'Repository URL'
        ])
        
        for repo in repos:
            writer.writerow([
                repo['name'],
                repo.get('visibility', 'N/A'),
                repo.get('updated_at', 'N/A'),
                repo.get('description', 'N/A').replace('\n', ' ') if repo.get('description') else 'N/A',
                alerts_count.get(repo['name'], 0),
                repo.get('html_url', 'N/A')
            ])

def main():
    print("Starting Dependabot report generation...")
    
    # Get repositories
    repos = get_org_repositories()
    print(f"Found {len(repos)} non-archived repositories")
    
    # Track alerts count per repository
    alerts_count = {}
    
    # Prepare CSV file for vulnerabilities
    with open(OUTPUT_FILE, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([
            'Repository',
            'Package Name',
            'Vulnerable Version',
            'Patched Version',
            'Severity',
            'Summary',
            'Description',
            'First Detected',
            'Alert URL',
            'Repository Visibility'
        ])
        
        # Process each repository
        for repo in repos:
            repo_name = repo['name']
            print(f"Processing {repo_name}...")
            
            alerts = get_dependabot_alerts(repo_name)
            alerts_count[repo_name] = len(alerts)
            
            if alerts:
                print(f"Found {len(alerts)} high/critical alerts in {repo_name}")
                
                # Write alerts to CSV
                for alert in alerts:
                    advisory = alert.get('security_advisory', {})
                    dependency = alert.get('dependency', {})
                    package = dependency.get('package', {})
                    
                    writer.writerow([
                        repo_name,
                        package.get('name', 'N/A'),
                        dependency.get('vulnerable_version_range', 'N/A'),
                        advisory.get('patched_version', 'Not specified'),
                        advisory.get('severity', 'N/A'),
                        advisory.get('summary', 'N/A'),
                        advisory.get('description', 'N/A').replace('\n', ' ') if advisory.get('description') else 'N/A',
                        alert.get('created_at', 'N/A'),
                        alert.get('html_url', 'N/A'),
                        repo.get('visibility', 'N/A')
                    ])
            else:
                print(f"No high/critical alerts found in {repo_name}")
    
    # Generate repositories report
    write_repositories_report(repos, alerts_count)

    print(f"\nReport generation completed.")
    print(f"Vulnerabilities report saved to: {OUTPUT_FILE}")
    print(f"Repositories scanning report saved to: {REPOS_SCANNED_FILE}")

if __name__ == "__main__":
    main()
