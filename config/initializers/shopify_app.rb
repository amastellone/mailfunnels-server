ShopifyApp.configure do |config|

  config.application_name = ENV['APP_NAME']
  config.api_key = ENV['APP_KEY']
  config.secret = ENV['APP_SECRET']

  # TODO: Verify app_scope works in shipify_app.rb and in .env
  config.scope = "read_orders, read_products"
  config.embedded_app = true

  config.webhooks = [
    {topic: 'orders/create', address: 'https://5a4f004d.ngrok.io/webhooks/orders_create', format: 'json'},
    {topic: 'carts/update', address: 'https://5a4f004d.ngrok.io/webhooks/carts_update', format: 'json'},
  ]
end
