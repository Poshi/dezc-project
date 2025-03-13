#!/usr/bin/env bash

env_file=".env"
secrets_env_file=".env_encoded"

terraform apply -destroy -auto-approve
rm "${env_file}" "${secrets_env_file}"
