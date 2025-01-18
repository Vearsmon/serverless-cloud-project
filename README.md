# Сайт чата-флудилки c Serverless архитектурой

Вместо команд Yandex CLI используется инструмент Terraform (>= v1.9.8) с yaml-подобным синтаксисом. С помощью него можно декларативно описывать, какие ресурсы требуется создать в Yandex Cloud, и более удобно посмотреть, из чего эти ресурсы построены. И команды становятся короче.

## Запуск в собственном облаке

Для запуска ресурсов в своем облаке требуется изменить реквизиты в файле provider.tf, а именно `OAuth-токен`, `cloud_id` и `folder_id` вашего облака.

1. Сформируйте архивы для развертывания облачных функций:
```
zip save-function.zip select-function.py requirements.txt
zip save-function.zip save-function.py requirements.txt
```
2. Находясь в каталоге проекта, примените по очереди команды:
```
terraform apply -target=yandex_iam_service_account.chat_api_sa
terraform apply -target=yandex_iam_service_account_static_access_key.chat_api_sa_static_key
terraform apply -target=yandex_resourcemanager_folder_iam_member.sa-editor
terraform apply -target=yandex_ydb_database_serverless.chat_database
terraform apply -target=yandex_ydb_table.messages
terraform apply -target=yandex_function.insert_ydb_table_function
terraform apply -target=yandex_function.select_ydb_table_function
```
3. Модифицируйте `gateway.tf`, поместив в него значения выведенных `insert_ydb_table_function_id` и `select_ydb_table_function_id`
4. Примените команду ```terraform apply -target=yandex_api_gateway.chat_api_gateway```
5. Примените `terraform apply` для развертывания оставшихся ресурсов для Object Storage.
6. Измените URL домена API Gateway в файле `chat.html` на выведенный `api_gateway_domain`.
7. Готово! Если вы не изменяли данные в `bucket.tf`, страница будет доступна по адресу `http://website.yandexcloud.net/www.chat-vearsmon.com`