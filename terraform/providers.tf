terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0.0"
    }
  }  
}

provider "azurerm" {
  features {}
}

provider "google" {
  credentials = file("gcp-key.json")
  project = "learn-k8s-the-hard-way-356809"
  region  = "northamerica-northeast1"
  zone    = "northamerica-northeast1-a"
}
