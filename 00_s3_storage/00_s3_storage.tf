terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  folder_id                = var.cloud.folder_id
  zone                     = var.cloud.default_zone
  service_account_key_file = file("marsel-key.json")
  cloud_id                 = var.cloud.cloud_id
}
resource "yandex_iam_service_account" "service_account_s3" {
  name        = var.service_account_s3.name
  description = "Сервисная УЗ для S3 бакета"
  folder_id   = var.service_account_s3.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "service_account_editor" {
  folder_id  = var.cloud.folder_id
  role       = "storage.editor"
  member     = "serviceAccount:${yandex_iam_service_account.service_account_s3.id}"
  depends_on = [yandex_iam_service_account.service_account_s3]
}

resource "yandex_iam_service_account_static_access_key" "service_account_key" {
  service_account_id = yandex_iam_service_account.service_account_s3.id
  description        = "static access key for object storage"
  depends_on         = [yandex_resourcemanager_folder_iam_member.service_account_editor]
}

resource "yandex_storage_bucket" "object_storage" {
  depends_on = [yandex_iam_service_account_static_access_key.service_account_key]
  bucket     = "marsel.valiev"
  access_key = yandex_iam_service_account_static_access_key.service_account_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.service_account_key.secret_key
}

