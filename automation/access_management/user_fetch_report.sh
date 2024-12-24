#!/bin/bash

# Install pyGithub if not already installed
if ! command -v aws &> /dev/null; then
    echo "Installing pyGithub..."
    pip install PyGithub --upgrade --user
fi

# Replace SLACK_WEBHOOK_URL with your Slack webhook URL
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/abc" #change slack webhook url

# Run the Python script and capture the output
output=$(python2 ./github_org_users.py)

# Define the message and format the output as critical with emojis
message=":rotating_light: *CRITICAL*: These are the members of Orgname GitHub Organization:\n\n$output"

# Send the message and output to the Slack webhook
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" "$SLACK_WEBHOOK_URL"
