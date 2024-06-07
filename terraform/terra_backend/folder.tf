

resource "yandex_resourcemanager_folder" "neto-folder" {
  cloud_id    = var.cloud_id
  name        = "neto-diplom6"
  description = "Каталог для диплома нетологии"
}
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = yandex_resourcemanager_folder.neto-folder.id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.neto.id}"
}


