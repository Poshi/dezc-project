variable "credentials" {
  description = "GCP Credentials"
  default     = "~/.gcp/green-calling-444717-c7-e5913373d028.json"
}

variable "project" {
  description = "Project ID"
  default     = "green-calling-444717-c7"
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
