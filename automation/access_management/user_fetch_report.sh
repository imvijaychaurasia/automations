#!/bin/bash

# Install pyGithub if not already installed
if ! command -v aws &> /dev/null; then
    echo "Installing pyGithub..."
    pip install PyGithub --upgrade --user
fi

# Replace SLACK_WEBHOOK_URL with your Slack webhook URL
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"

# Run the Python script and capture the output
output=$(python2 ./bizongo_org_github_users.py)

# Define the message and format the output as critical with emojis
message=":rotating_light: *CRITICAL*: These are the members of Bizongo's GitHub Organization:\n\n$output"

# Send the message and output to the Slack webhook
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" "$SLACK_WEBHOOK_URL"
