#!/usr/bin/env bash

env_file=".env"
secrets_env_file=".env_encoded"

# Set credentials_file to point to your GCP service account key file
credentials_file=~/.gcp/green-calling-444717-c7-e5913373d028.json

# Setup credentials data
echo "SECRET_GCP_SERVICE_ACCOUNT=$(<"${credentials_file}" base64 -w 0)" > "${secrets_env_file}"

# Setup GCS resources
terraform init
terraform apply -auto-approve

# Generate the environment file for Kestra to know the names of the resources
:> "${env_file}"
tf_vars=$(terraform output -json)
printf "KESTRA_GCP_PROJECT_ID=%s\n" $(<<<"${tf_vars}" jq -r '.project_id.value') >> "${env_file}"
printf "KESTRA_GCP_BUCKET_NAME=%s\n" $(<<<"${tf_vars}" jq -r '.bucket_name.value') >> "${env_file}"
printf "KESTRA_GCP_DATASET_NAME=%s\n" $(<<<"${tf_vars}" jq -r '.dataset_name.value') >> "${env_file}"
