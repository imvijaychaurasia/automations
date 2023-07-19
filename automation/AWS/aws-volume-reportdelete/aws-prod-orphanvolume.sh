#!/bin/bash

# Install AWS CLI if not already installed
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    pip install awscli --upgrade --user
fi

# Set AWS access keys
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION=ap-south-1

# Fetch volumes in available state
volume_report=$(aws ec2 describe-volumes --filters Name=status,Values=available --query 'Volumes[*].[VolumeId,Size,AvailabilityZone]' --output table)

# Check if there are volumes in available state
if [ -z "$volume_report" ]; then
  # No volumes in available state found
  echo "No volumes in available state found."
  
  # Send message to Slack with no volumes found
  slack_message=":white_check_mark: AWS Prod - Congratulations! Your Volumes are clean and in excellent shape. There are no orphaned Volumes found in ap-south-1 region to worry about."
  SLACK_PAYLOAD="{\"text\": \"$slack_message\"}"
  curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" https://hooks.slack.com/services/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
else
  # Volumes in available state found
  echo "The following volumes are in available state:"
  echo "$volume_report"
  
  # Send report to Slack
  slack_message=":warning: AWS Prod - CRITICAL ISSUE: We have found orphan volumes are in ap-south-1 region:\n\n$volume_report\n\nProceeding with deletion of the reported volumes."
  SLACK_PAYLOAD="{\"text\": \"$slack_message\"}"
  curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" https://hooks.slack.com/services/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
  
  # Proceed with deleting volumes in available state
  echo "Deleting volumes in available state..."
  while read -r volume_id; do
    echo "Deleting volume with ID: $volume_id"
    aws ec2 delete-volume --volume-id "$volume_id"
  done <<< "$volume_report"
  
fi
