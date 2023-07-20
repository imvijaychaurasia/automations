#!/bin/bash

# Set AWS access keys
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"

# Set AWS region
export AWS_DEFAULT_REGION="YOUR_AWS_REGION"

# Generate the current date
current_date=$(date +"%Y-%m-%d")

# Create the CSV file
csv_filename="IAM_Report_${current_date}.csv"
echo "IAM User Name,Last Activity,Permissions/Roles,Attached Permission Policies,Access Keys,Created Date,Last Console Sign-In,Console Access Status,Active Access Key" > "$csv_filename"

# Fetch list of IAM users
iam_users=$(aws iam list-users --region "$AWS_DEFAULT_REGION" --output text --query 'Users[].UserName')

# Loop through each IAM user
for iam_user in $iam_users; do
  echo "Processing IAM User: $iam_user"

  # Get last activity
  last_activity=$(aws iam get-user-last-accessed-info --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --output text --query 'ServicesLastAccessed[].LastAuthenticated')
  
  # Get permissions or roles associated with the IAM user
  permissions=$(aws iam list-attached-user-policies --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --output text --query 'AttachedPolicies[].PolicyName')
  
  # Get attached permission policies
  attached_policies=$(aws iam list-attached-user-policies --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --output text --query 'AttachedPolicies[].PolicyArn')
  
  # Get access keys
  access_keys=$(aws iam list-access-keys --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --output text --query 'AccessKeyMetadata[].AccessKeyId')
  
  # Get creation date
  created_date=$(aws iam get-user --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --query 'User.CreateDate' --output text)
  
  # Get last console sign-in
  last_signin=$(aws iam get-user --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --query 'User.PasswordLastUsed' --output text)
  
  # Get console access status
  console_status=$(aws iam get-user --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --query 'User.Enabled' --output text)
  
  # Get active access key
  active_access_key=$(aws iam list-access-keys --user-name "$iam_user" --region "$AWS_DEFAULT_REGION" --output text --query 'AccessKeyMetadata[?Status==`Active`].AccessKeyId')

  # Append user details to the CSV file
  echo "$iam_user,$last_activity,$permissions,$attached_policies,$access_keys,$created_date,$last_signin,$console_status,$active_access_key" >> "$csv_filename"

  echo "Processed IAM User: $iam_user"
done

echo "Report generation complete. CSV file saved as: $csv_filename"
