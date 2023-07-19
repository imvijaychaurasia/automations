---

<h1 align="center">Jenkins Job - Unattached Security Groups Report</h1>
<p align="center">Automating the generation of a report for unattached security groups in AWS using Jenkins and AWS CLI.</p>

## Overview
This repository contains a Jenkins job that automates the process of generating a report for unattached security groups in AWS. The job utilizes a freestyle project with an executable shell script. The script interacts with the AWS Command Line Interface (CLI) and sends the report to a Slack channel using a webhook.

## Steps
1. **Install AWS CLI**: Checks if the AWS CLI is installed and installs it if necessary.
2. **Set AWS Credentials**: Sets the AWS credentials using Jenkins parameters.
3. **Fetch Unattached Security Groups**: Retrieves a report of unattached security groups from AWS EC2.
4. **Customize Slack Message**: Formats the report into a Slack message with critical issue highlighting.
5. **Send Slack Notification**: Sends the Slack message to a specified channel using a webhook.

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
- Modifying the AWS CLI command to fetch different types of resources or add additional filters.
- Adjusting the Slack message formatting to include more information or different highlighting.
- Integrate other notification channels or reporting mechanisms.

## Important Note
Please ensure that you have reviewed and customized the Slack webhook URL in the script to match your own Slack integration. Otherwise, the Slack notifications will not work correctly.
For any questions or issues, please contact DevOps/InfraOps team.

Happy automation!

---
