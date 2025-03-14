variable "credentials" {
  description = "GCP Credentials"
  default     = "~/.gcp/gcp_keys.json"
}

variable "project" {
  description = "Project ID"
  default     = "molten-smithy-453622-n8"
}

variable "region" {
  description = "Region"
  default     = "us-east1"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "DEZC project BigQuery Dataset"
  default     = "dezc_project_dataset"
}

variable "gcs_bucket_name" {
  description = "DEZC project storage Bucket"
  default     = "dezc_project_bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
