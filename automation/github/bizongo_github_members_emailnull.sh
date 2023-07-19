  message=":rotating_light: :rotating_light: :exploding_head: Here are the Bizongo's Github Members whose account email id could not be fetched :sob: \n"

  for login in $member_logins; do
    # Fetch member details to get the email ID
    member_response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/users/$login" 2>/dev/null)

    # Extract the email ID from the member details
    email_id=$(echo "$member_response" | grep -oP '(?<="email": ")[^"]*')

    # Check if the email ID is null
    if [ -z "$email_id" ]; then
      message+="$login\n"
    fi
  done

  # Send message to Slack webhook if there are members with null email IDs
  if [[ $message != ":rotating_light: Members in $ORG_NAME Org with Null Email IDs:\n" ]]; then
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"$message\"}" \
      "$SLACK_WEBHOOK_URL"
  else
    echo "No members found with null email IDs in $ORG_NAME"
  fi
else
  echo "Failed to fetch members in $ORG_NAME"
fi
