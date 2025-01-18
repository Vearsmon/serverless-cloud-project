resource "yandex_function" "select_ydb_table_function" {
  name               = "select-ydb-table-function"
  runtime            = "python312"
  entrypoint         = "select-function.handler"
  memory             = "128"
  execution_timeout  = "3"
  service_account_id = "${yandex_iam_service_account.chat_api_sa.id}"
  user_hash = "0000000000"
  environment = {
    YDB_ENDPOINT = "${split("/?database=", regex(".*/?database=", yandex_ydb_table.messages.connection_string))[0]}"
    YDB_DATABASE = "${yandex_ydb_database_serverless.chat_database.database_path}"
  }
  content {
    zip_filename = "select-function.zip"
  }
}

output select_ydb_table_function_id {
  value = yandex_function.select_ydb_table_function.id
}
