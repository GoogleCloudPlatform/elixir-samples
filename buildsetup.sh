#! /bin/bash

# This script will configure a given GCP project to use
# Workload Identity Federation.  To learn more, see:
# https://github.com/google-github-actions/auth

export PROJECT_ID="gcp-elixir"
export POOL_NAME="github-actions-pool"
export PROVIDER_NAME="github-actions-provider"
export SERVICE_ACCOUNT="elixir-samples-tests@gcp-elixir.iam.gserviceaccount.com"
export GITHUB_REPO="GoogleCloudPlatform/elixir-samples"

set -x

# Enable the IAM Credentials API
gcloud services enable iamcredentials.googleapis.com --project "${PROJECT_ID}"

# Create a workload identity pool
gcloud iam workload-identity-pools create "${POOL_NAME}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="GitHub Actions Pool"

# Get the full ID of the Workload Identity Pool
export WORKLOAD_IDENTITY_POOL_ID="`gcloud iam workload-identity-pools describe "${POOL_NAME}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --format="value(name)"`"

# Create a Workload Identity Provider in that pool
gcloud iam workload-identity-pools providers create-oidc "${PROVIDER_NAME}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${POOL_NAME}" \
  --display-name="GitHub Actions Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Allow authentications from the Workload Identity Provider to impersonate the Service Account.
# Note executions are limited to requests from this specific repository.
gcloud iam service-accounts add-iam-policy-binding "${SERVICE_ACCOUNT}" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${GITHUB_REPO}"
