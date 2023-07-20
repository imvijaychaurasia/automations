#!/bin/bash

# Install AWS CLI if not already installed
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    pip install awscli --upgrade --user
fi

# Set AWS access keys
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"

# Fetch the snapshots with the specified tag
snapshot_report=$(aws ec2 describe-snapshots --filters "Name=tag:spotinst:accountId,Values=act-89c412a2" --query 'Snapshots[*].[SnapshotId, VolumeId, StartTime]' --output table)

# Customize the Slack message
slack_message=":rotating_light: CRITICAL ISSUE: These are Snapshots created by Spot.io for Dev-VMs:\n\n${snapshot_report}"

# Send the report to Slack via webhook
SLACK_PAYLOAD="{\"text\": \"$slack_message\"}"
curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" https://hooks.slack.com/services/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
#curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" $WEBHOOK_URL

# Delete the snapshots listed in the report
###while read -r snapshot_id; do
###    echo "Deleting snapshot: $snapshot_id"
###    aws ec2 delete-snapshot --snapshot-id "$snapshot_id"
###done <<< "$(echo "$snapshot_report" | awk '{print $1}')"

# Set the AWS CLI region
export AWS_DEFAULT_REGION=ap-south-1

# Get the list of snapshot IDs with the specified tag
snapshot_ids=$(aws ec2 describe-snapshots --filters "Name=tag-key,Values=spotinst:accountId" "Name=tag-value,Values=act-89c412a2" --query "Snapshots[].SnapshotId" --output text)

# Delete each snapshot
for snapshot_id in $snapshot_ids; do
    aws ec2 delete-snapshot --snapshot-id $snapshot_id
done


# Send the deletion success message to Slack
deleted_snapshots=$(echo "$snapshot_report" | awk '{print $1}' | paste -sd ',')
success_message=":white_check_mark: Successfully deleted the following snapshots: $deleted_snapshots"
SLACK_PAYLOAD="{\"text\": \"$success_message\"}"
curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" https://hooks.slack.com/services/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
#curl -X POST -H 'Content-type: application/json' --data "$SLACK_PAYLOAD" $WEBHOOK_URL
