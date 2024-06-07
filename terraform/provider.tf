terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    local = {
      source = "registry.terraform.io/hashicorp/local"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "ter-data-netology1"
    region = "ru-central1"
    key    = "./neto.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

  }
}



provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  zone      = var.default_zone
  folder_id = var.folder_id
}
