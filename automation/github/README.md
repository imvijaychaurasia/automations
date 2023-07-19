# Bizongo's Github Management Scripts
This repository contains scripts for managing repositories and members in a Bizongo GitHub.
The scripts provide functionality for archiving and unarchiving repositories, fetching lists of repositories and organization members, and retrieving unarchived public repositories.

## Scripts
This repository contains the following scripts:
- `archive_repos.sh`: Archives multiple repositories in the organization.
- `unarchive_repos.sh`: Unarchives multiple repositories in the organization.
- `bizongo_repo_list.sh`: Fetches a list of all repositories in the organization.
- `bizongo_github_members.sh`: Fetches a list of organization members with their email addresses.
- `unarchived_public_repos.sh`: Fetches a list of unarchived public repositories in the organization.
- `remove_githubmember_withnoemail.sh`: Fetches list of members with email id private, removes them from the organization.
Each script can be executed individually and provides specific functionality.

### Usage and Precautions
Before running any of the scripts, ensure that you have set up the necessary configurations and reviewed the parameters. Be cautious and follow these precautions:
- Double-check the list of repositories or members to be modified or fetched to avoid unintended changes.
- Ensure that you have the appropriate permissions to perform the operations.
- Review and customize the scripts to match your organization's setup and requirements.
- Consider testing the scripts on a subset of repositories or members before applying them to the entire organization.

It is recommended to generate a personal access token with the minimum required permissions for repository and member management.
Please exercise caution when running the scripts and consider backing up your data before making any changes.
