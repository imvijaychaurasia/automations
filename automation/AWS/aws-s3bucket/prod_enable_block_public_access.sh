#!/bin/bash

# Set AWS credentials
export AWS_ACCESS_KEY_ID="<key>"
export AWS_SECRET_ACCESS_KEY="<secrete>"

# Slack webhook URL
SLACK_WEBHOOK_URL="<slack_webhook>"

# Read S3 bucket list from file
buckets=$(cat prod_s3bucket_block_publicaccess.txt)

# Check if any buckets exist
if [ -n "$buckets" ]; then
    # Initialize message
    message=":rotating_light: AWS Prod - Enabling 'Block All Public Access' for the following S3 buckets:\n\n Ref - Email: IMP | Security Compliance | Production S3 Bucket P$

    # Iterate over each bucket
    for bucket in $buckets; do
        # Enable 'Block all public access' for the bucket
        aws s3api put-public-access-block --bucket "$bucket" --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictP$
        message+="• $bucket\n"
    done

    # Send message to Slack - Buckets to be enabled
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" "$SLACK_WEBHOOK_URL"

    # Send message to Slack - Job completion status
    completion_message=":white_check_mark: AWS Prod | Successfully Enabled :party-blob: The following S3 buckets are no longer Publicly Accessible :party-parrot:\n • $bucket$
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$completion_message\"}" "$SLACK_WEBHOOK_URL"
else
    echo "No S3 buckets found."
fi
