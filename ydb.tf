resource "yandex_ydb_database_serverless" "chat_database" {
  name      = "chat-database"
  folder_id = local.folder_id
}

output "chat_database_document_api_endpoint" {
  value = yandex_ydb_database_serverless.chat_database.document_api_endpoint
}

output "chat_database_path" {
  value = yandex_ydb_database_serverless.chat_database.database_path
}
