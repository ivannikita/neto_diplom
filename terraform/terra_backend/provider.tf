terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    local = {
      source = "registry.terraform.io/hashicorp/local"
    }
  }
}

resource "yandex_iam_service_account" "neto" {
  name      = "service-netology-diplom"
  folder_id = yandex_resourcemanager_folder.neto-folder.id
}

resource "yandex_iam_service_account_static_access_key" "neto-static-key" {
  service_account_id = yandex_iam_service_account.neto.id
  description        = "static access key for object storage"
}
resource "yandex_resourcemanager_folder_iam_member" "neto-editor" {
  folder_id = yandex_resourcemanager_folder.neto-folder.id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.neto.id}"
}
resource "yandex_resourcemanager_folder_iam_member" "neto-configurer" {
  folder_id = yandex_resourcemanager_folder.neto-folder.id
  role      = "storage.configurer"
  member    = "serviceAccount:${yandex_iam_service_account.neto.id}"
}

resource "yandex_storage_bucket" "ter-data" {
  access_key = yandex_iam_service_account_static_access_key.neto-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.neto-static-key.secret_key
  bucket     = "ter-data-netology1"
  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["PUT", "POST"]
  #   allowed_origins = ["https://s3-website-test.hashicorp.com"]
  #   expose_headers  = ["ETag"]
  #   max_age_seconds = 3000
  # }
  policy = <<POLICY
    {
        "Statement": {
        "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:GetBucketCORS",
            "s3:GetBucketWebsite"
        ],
        "Effect": "Allow",
        "Principal": "*",
        "Resource": [
            "arn:aws:s3:::ter-data-netology1/*",
            "arn:aws:s3:::ter-data-netology1"
        ]
    },
    "Version": "2012-10-17"
  }
  
  POLICY
}

provider "yandex" {
  token    = var.token
  cloud_id = var.cloud_id
  zone     = var.default_zone
}

