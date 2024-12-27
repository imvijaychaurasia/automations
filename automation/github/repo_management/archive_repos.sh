#!/bin/bash

# Personal access token with repo scope
ACCESS_TOKEN="<your-access-token>"
# Organization name
ORG_NAME="<org>"
# Path to the file containing the list of repository names
REPO_LIST_FILE="repository_list.txt" #file which is only repo name, with each in one line
# Slack webhook URL
SLACK_WEBHOOK_URL="<slack-webhook-url>" #notification channel

# Read repository names from the file and archive each one
while IFS= read -r repo_name
do
  # Archive the repository using the GitHub API
  response=$(curl -X PATCH \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$ORG_NAME/$repo_name" \
    -d '{"archived": true}' 2>/dev/null)

  # Check if the response contains an "archived" key
  if [[ $response == *"\"archived\": true"* ]]; then
    echo "Archived repository: $ORG_NAME/$repo_name"

    # Send message to Slack webhook
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\":rotating_light: The Bizongo's GitHub repository $ORG_NAME/$repo_name has been archived.\"}" \
      "$SLACK_WEBHOOK_URL"
  else
    echo "Failed to archive repository: $ORG_NAME/$repo_name"
  fi
done < "$REPO_LIST_FILE"
