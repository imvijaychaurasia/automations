#!/bin/bash

# Personal access token with read:org and delete:org scope
ACCESS_TOKEN="<your-access-token>"
# Organization name
ORG_NAME="bizongo"
# Slack webhook URL
SLACK_WEBHOOK_URL="<slack-webhook-url>"

# Fetch all members in the organization
response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$ORG_NAME/members?per_page=100" 2>/dev/null)

# Check if response contains members
if [[ $response == *"\"login\":"* ]]; then
  # Extract member logins and fetch email IDs for each member
  member_logins=$(echo "$response" | grep -oP '(?<="login": ")[^"]*')

  # Prepare list of members to be removed
  members_to_remove=":rotating_light: Bizongo Github | Here are the Members whose email id could not be fetched, and thus are being removed from $ORG_NAME:\n"

  for login in $member_logins; do
    # Fetch member details to get the email ID
    member_response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/users/$login" 2>/dev/null)

    # Extract the email ID from the member details
    email_id=$(echo "$member_response" | grep -oP '(?<="email": ")[^"]*')

    # Check if email ID is null
    if [ -z "$email_id" ]; then
      members_to_remove+="• $login\n"
      
      # Remove member from the organization
      curl -X DELETE \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        "https://api.github.com/orgs/$ORG_NAME/members/$login"
    fi
  done

  # Send message to Slack webhook
  curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$members_to_remove\"}" \
    "$SLACK_WEBHOOK_URL"
else
  echo "Failed to fetch members in $ORG_NAME"
fi
