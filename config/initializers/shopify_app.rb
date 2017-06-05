ShopifyApp.configure do |config|

  config.application_name = ENV['APP_NAME']
  config.api_key = ENV['APP_KEY']
  config.secret = ENV['APP_SECRET']

  # TODO: Verify app_scope works in shipify_app.rb and in .env
  config.scope = "read_orders, read_products"
  config.embedded_app = true

  config.webhooks = [
    #{topic: 'refunds/create', address: 'https://www.mailfunnels.com/webhooks/refunds_create', format: 'json'},
    #{topic: 'orders/create', address: 'https://www.mailfunnels.com/webhooks/orders_create', format: 'json'},
    #{topic: 'carts/update', address: 'https://www.mailfunnels.com/webhooks/carts_update', format: 'json'},
    {topic: 'refunds/create', address: 'https://9f9746f7.ngrok.io/webhooks/refunds_create', format: 'json'},
    {topic: 'orders/create', address: 'https://9f9746f7.ngrok.io/webhooks/orders_create', format: 'json'},
    {topic: 'carts/update', address: 'https://9f9746f7.ngrok.io/webhooks/carts_update', format: 'json'},
  ]
end
