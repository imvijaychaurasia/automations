!/bin/bash

# Personal access token with repo scope
ACCESS_TOKEN="<access_token>"
# Organization name
ORG_NAME="<org>"
# Slack webhook URL
SLACK_WEBHOOK_URL="<slack_webhook_url>"

# Fetch all members in the organization
response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$ORG_NAME/members?per_page=100" 2>/dev/null)

# Check if response contains members
if [[ $response == *"\"login\":"* ]]; then
  # Extract member logins and fetch email IDs for each member
  member_logins=$(echo "$response" | grep -oP '(?<="login": ")[^"]*')

  # Prepare message for Slack webhook
  message=":white_check_mark: :cool-doge: Here are the Bizongo's Github Members with their Email IDs :party-blob:\n"

  for login in $member_logins; do
    # Fetch member details to get the email ID
    member_response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/users/$login" 2>/dev/null)

    # Extract the email ID and username from the member details
    email_id=$(echo "$member_response" | grep -oP '(?<="email": ")[^"]*')
    username=$(echo "$member_response" | grep -oP '(?<="login": ")[^"]*')

    # Check if the email ID is not null
    if [[ -n "$email_id" && "$email_id" != "null" ]]; then
      message+=" $username $email_id\n"
    fi
  done
  
  # Send message to Slack webhook if there are members with non-null email IDs
  if [[ $message != ":rotating_light: Here are the Github Members in $ORG_NAME Org with Non-Null Email IDs:\n" ]]; then
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"$message\"}" \
      "$SLACK_WEBHOOK_URL"
  else
    echo "No members found with non-null email IDs in $ORG_NAME"
  fi
else
  echo "Failed to fetch members in $ORG_NAME"
fi
