resource "yandex_storage_bucket" "chat" {
  access_key = yandex_iam_service_account_static_access_key.chat_api_sa_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.chat_api_sa_static_key.secret_key
  bucket     = "www.chat-vearsmon.com"
  acl        = "public-read"
  
  website {
    index_document = "chat.html"
  }
}

resource "yandex_storage_object" "chat-html" {
  access_key = yandex_iam_service_account_static_access_key.chat_api_sa_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.chat_api_sa_static_key.secret_key
  bucket     = yandex_storage_bucket.chat.id
  key        = "chat.html"
  source     = "chat.html"
}

resource "yandex_dns_zone" "zone1" {
  name        = "example-zone-1"
  description = "Public zone"
  zone        = "chat-vearsmon.com."
  public      = true
}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "www"
  type    = "CNAME"
  ttl     = 200
  data    = ["www.chat-vearsmon.com.website.yandexcloud.net."]
}
