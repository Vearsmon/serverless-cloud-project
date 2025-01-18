resource "yandex_api_gateway" "chat_api_gateway" {
  name        = "chat-api-gateway"
  spec = <<-EOT
    openapi: "3.0.0"
    info:
      version: 1.0.0
      title: Chat API
    x-yc-apigateway:
      cors:
        origin: '*'
        methods: '*'
        allowedHeaders: '*'
    paths:
      /select:
        get:
          x-yc-apigateway-integration:
            type: cloud-functions
            function_id: "<select_function_id>"
      /insert:
        post:
          x-yc-apigateway-integration:
            type: cloud-functions
            function_id: "<insert_function_id>"
EOT
}

output "api_gateway_domain" {
  value = yandex_api_gateway.chat_api_gateway.domain
}