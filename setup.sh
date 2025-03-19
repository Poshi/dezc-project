#!/usr/bin/env bash

set -euo pipefail

usage() {
    printf "Usage: %s [init|destroy]\n" "${0}"
}

# Check command line parameters
if [ "${#}" -ne 1 ]; then
    usage
    exit 1
fi

if [ "${1}" != "init" ] && [ "${1}" != "destroy" ]; then
    usage
    exit 1
fi

# Set credentials_file to point to your GCP service account key file
credentials_file=~/.gcp/gcp_keys.json

# Output files
env_file=".env"
secrets_env_file=".env_encoded"

# Setup Terraform variables
TF_VAR_credentials="${credentials_file}"
TF_VAR_project="$(jq -r '.project_id' "${credentials_file}")"
TF_VAR_gcs_bucket_name="dezc_bucket_${TF_VAR_project//-/_}"
TF_VAR_bq_dataset_name="dezc_dataset_${TF_VAR_project//-/_}"
export TF_VAR_credentials TR_VAR_project TF_VAR_project TF_VAR_gcs_bucket_name TF_VAR_bq_dataset_name

# Process destroy option
if [ "${1}" == "destroy" ]
then
    terraform apply -destroy -auto-approve
    rm "${env_file}" "${secrets_env_file}"
    exit 0
fi

# Here we are with the init option
# Create obfuscated environment file with credentials data for Kestra
echo "SECRET_GCP_SERVICE_ACCOUNT=$(<"${credentials_file}" base64 -w 0)" > "${secrets_env_file}"

# Generate the environment file for Kestra to know the names of the resources
{
    printf "KESTRA_GCP_PROJECT_ID=%s\n" "${TF_VAR_project}"
    printf "KESTRA_GCP_BUCKET_NAME=%s\n" "${TF_VAR_gcs_bucket_name}"
    printf "KESTRA_GCP_DATASET_NAME=%s\n" "${TF_VAR_bq_dataset_name}"
} > "${env_file}"

# Setup GCS resources with Terraform
terraform init
terraform apply -auto-approve

# Start Kestra and wait for it to be up
docker compose up -d
while ! curl -s -o /dev/null http://localhost:8080/
do
    sleep 1
done

# Upload the flow to Kestra
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@load_year.yml

# Launch backfill jobs
curl -s -X PUT http://localhost:8080/api/v1/triggers --json '{"flowId": "load_year", "namespace": "dezc", "triggerId": "schedule", "backfill": {"start": "2021-01-01T00:00:00Z", "end": "'"$(date +%Y)"'-12-31T00:00:00Z"}}'
