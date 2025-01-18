resource "yandex_ydb_table" "messages" {
  path = "messages"
  connection_string = yandex_ydb_database_serverless.chat_database.ydb_full_endpoint 
  
column {
      name = "id"
      type = "Utf8"
      not_null = true
    }
    column {
      name = "user_id"
      type = "Utf8"
      not_null = true
    }
    column {
      name = "message_text"
      type = "Utf8"
      not_null = true
    }
    column {
      name = "sending_time"
      type = "Utf8"
      not_null = true
    }

  primary_key = ["id"] 
}

output "chat_database_messages_table_path" {
  value = yandex_ydb_table.messages.connection_string
}
