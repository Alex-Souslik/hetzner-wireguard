terraform {
  required_version = ">= 1.4.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.48.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.40.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}
