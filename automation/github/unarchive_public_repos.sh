!/bin/bash

# Personal access token with repo scope
ACCESS_TOKEN="<access_token>"
# Organization name
ORG_NAME="bizongo"
# Slack webhook URL
SLACK_WEBHOOK_URL="<Slack_webhook>"

# Fetch all unarchived public repositories
response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$ORG_NAME/repos?per_page=100&page=1&archived=false&type=public" 2>/dev/null)

# Check if response contains repositories
if [[ $response == *"\"name\":"* ]]; then
  # Extract repository names from the response
  repo_names=$(echo "$response" | grep -oP '(?<="name": ")[^"]*')

  # Prepare message for Slack webhook
  message=":rotating_light: These are Unarchived Public repositories in $ORG_NAME:\n"
  while IFS= read -r repo_name; do
    message+="• $repo_name\n"
  done <<< "$repo_names"

  # Send message to Slack webhook
  curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$message\"}" \
    "$SLACK_WEBHOOK_URL"
else
  echo "Failed to fetch public unarchived repositories in $ORG_NAME"
fi
