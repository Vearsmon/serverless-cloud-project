resource "yandex_iam_service_account" "chat_api_sa" {
  name        = "chat-api-sa-${local.folder_id}"
  description = "Service account to call chat-database"
}

resource "yandex_iam_service_account_static_access_key" "chat_api_sa_static_key" {
  service_account_id = yandex_iam_service_account.chat_api_sa.id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.chat_api_sa.id}"
}

output "chat_api_sa_id" {
  value = yandex_iam_service_account.chat_api_sa.id
}
