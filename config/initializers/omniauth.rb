Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shopify,
           ShopifyApp.configuration.api_key,
           ShopifyApp.configuration.secret,
           :callback_url =>  "https://a55bda40.ngrok.io/mailfunnels_auth",
           scope: ShopifyApp.configuration.scope
end
