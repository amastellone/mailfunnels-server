ShopifyApp.configure do |config|

  config.application_name = ENV['APP_NAME']
  config.api_key = ENV['APP_KEY']
  config.secret = ENV['APP_SECRET']

  # TODO: Verify app_scope works in shipify_app.rb and in .env
  config.scope = "read_orders, read_products, read_checkouts"
  config.embedded_app = true

  config.webhooks = [
    {topic: 'refunds/create', address: 'https://www.mailfunnels.com/webhooks/refunds_create', format: 'json'},
    {topic: 'orders/create', address: 'https://www.mailfunnels.com/webhooks/orders_create', format: 'json'},
    {topic: 'checkouts/create', address: 'https://www.mailfunnels.com/abandoned_cart_process', format: 'json'},
    # {topic: 'refunds/create', address: 'https://c7607382.ngrok.io/webhooks/refunds_create', format: 'json'},
    # {topic: 'orders/create', address: 'https://c7607382.ngrok.io/webhooks/orders_create', format: 'json'},
    # {topic: 'checkouts/create', address: 'https://c7607382.ngrok.io/abandoned_cart_process', format: 'json'},
  ]
end
