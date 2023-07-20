#!/bin/bash

# Personal access token with repo scope
ACCESS_TOKEN="<your-access-token>"
# Organization name
ORG_NAME="<org>"
# Path to the file containing the list of repository names
REPO_LIST_FILE="repository_list.txt"
# Slack webhook URL
SLACK_WEBHOOK_URL="<slack-webhook-url>"

# Read repository names from the file and unarchive each one
while IFS= read -r repo_name
do
  # Unarchive the repository using the GitHub API
  response=$(curl -X PATCH \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$ORG_NAME/$repo_name" \
    -d '{"archived": false}' 2>/dev/null)

  # Check if the response contains an "archived" key
  if [[ $response == *"\"archived\": false"* ]]; then
    echo "Unarchived repository: $ORG_NAME/$repo_name"

    # Send message to Slack webhook
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\":white_check_mark: The Bizongo's GitHub repository $ORG_NAME/$repo_name has been unarchived.\"}" \
      "$SLACK_WEBHOOK_URL"
  else
    echo "Failed to unarchive repository: $ORG_NAME/$repo_name"
  fi
done < "$REPO_LIST_FILE"
