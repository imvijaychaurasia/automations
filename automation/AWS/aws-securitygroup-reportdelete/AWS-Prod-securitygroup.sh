#!/bin/bash

# Install AWS CLI if not already installed
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    pip install awscli --upgrade --user
fi

# Set AWS credentials
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION=ap-south-1

# Fetch unattached security groups
security_group_report=$(aws ec2 describe-security-groups --query 'SecurityGroups[?length(Attachments)==`0`].[GroupId, GroupName]' --output table)

# Check if there are unattached security groups
if [ -z "$security_group_report" ]; then
  # No unattached security groups found
  echo "No unattached security groups found."
  
  # Send message to Slack with no security groups found
  slack_message=":white_check_mark: AWS Prod - Congratulations! Your Security Groups are clean and in excellent shape. There are no orphaned Security Groups found in ap-south-1 region to worry about."
  SLACK_PAYLOAD="{\"text\": \"$slack_message\"}"
  curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" https://hooks.slack.com/services/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
else
  # Unattached security groups found
  echo "The following security groups are unattached:"
  echo "$security_group_report"
  
  # Send report to Slack
  slack_message=":warning: AWS Prod - URGENT ALERT: Unattached Security Groups detected in ap-south-1 Region.:\n\n$security_group_report\n\nProceeding with the deletion of the reported Security Groups."
  SLACK_PAYLOAD="{\"text\": \"$slack_message\"}"
  curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" https://hooks.slack.com/services/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
  
  # Proceed with deleting the unattached security groups
  echo "Deleting the unattached security groups..."
  while read -r group_id _; do
    aws ec2 delete-security-group --group-id "$group_id"
  done <<< "$security_group_report"
fi
