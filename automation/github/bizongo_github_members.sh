#!/bin/bash

# Personal access token with repo scope
ACCESS_TOKEN="<access_token>"
# Organization name
ORG_NAME="bizongo"
# Slack webhook URL
SLACK_WEBHOOK_URL="<Slack_webhook>"

# Fetch all members in the organization
response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$ORG_NAME/members?per_page=100" 2>/dev/null)

# Check if response contains members
if [[ $response == *"\"login\":"* ]]; then
  # Extract member logins and fetch email IDs for each member
  member_logins=$(echo "$response" | grep -oP '(?<="login": ")[^"]*')

  # Prepare message for Slack webhook
  message=":rotating_light: Here are the Github Members in $ORG_NAME Org:\n"
  for login in $member_logins; do
    # Fetch member details to get the email ID
    member_response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/users/$login" 2>/dev/null)

    # Extract the email ID and username from the member details
    email_id=$(echo "$member_response" | grep -oP '(?<="email": ")[^"]*')
    username=$(echo "$member_response" | grep -oP '(?<="login": ")[^"]*')
    message+="Username: $username\nEmail ID: $email_id\n\n"
  done

  # Send message to Slack webhook
  curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$message\"}" \
    "$SLACK_WEBHOOK_URL"
else
  echo "Failed to fetch members in $ORG_NAME"
fi
