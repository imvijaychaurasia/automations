---

<h1 align="center">Orphan Volumes Deletion</h1>
<p align="center">Automating the process of deleting orphan volumes in the AWS Stage environment using Jenkins and AWS CLI.</p>

## Overview

This repository contains a Jenkins job that automates the process of deleting orphan volumes in the AWS Stage environment. The job utilizes a freestyle project with an executable shell script. The script interacts with the AWS Command Line Interface (CLI) and sends notifications to a Slack channel.

## Steps
1. **Install AWS CLI**: Checks if the AWS CLI is installed and installs it if necessary.
2. **Set AWS Credentials**: Sets the AWS credentials using Jenkins parameters.
3. **Fetch Volume Report**: Retrieves a report of volumes in the "available" state from AWS EC2.
4. **Send Slack Notification**: Sends a highly critical volume report to a Slack channel.
5. **Extract Volume IDs**: Extracts the volume IDs from the report.
6. **Check for Volumes**: If there are no volumes to delete, the job exits successfully.
7. **Send Deletion Warning**: Sends a Slack message with a warning before deleting the volumes.
8. **Delete Volumes**: Deletes the volumes one by one using the AWS CLI.
9. **Track Deletion Status**: Keeps track of successfully deleted volumes and failed deletion attempts.
10. **Send Completion Notification**: Sends a Slack message to notify the completion of the deletion process.

## Usage
1. Set up a Jenkins server and ensure it has the necessary permissions to interact with AWS services.
2. Install the AWS CLI on the Jenkins server if not already installed.
3. Create a Slack integration and obtain the incoming webhook URL.
4. Create a new freestyle Jenkins job.
5. In the job configuration, set up the necessary parameters, such as AWS credentials and Slack webhook URL.
6. Configure the job to execute the provided shell script.
7. Save the job configuration and run the job manually or schedule it as needed.

## Customization
Feel free to customize the script or job configuration to suit your specific needs. Some possible enhancements include:
- Adding error handling and logging for better troubleshooting.
- Implementing additional notifications or integrations.
- Extending the script to support multiple AWS environments or regions.

## Important Note
Please ensure that you have reviewed and customized the Slack webhook URLs in the script to match your own Slack integration. Otherwise, the Slack notifications will not work correctly.
For any questions or issues, please contact DevOps/InfrOps team.

Happy automation!

---
