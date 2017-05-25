Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shopify,
    ShopifyApp.configuration.api_key,
    ShopifyApp.configuration.secret,
       :redirect_uri => "https://a55bda40.ngrok.io/mailfunnels_auth",
       #callback_url => ShopifyApp.configuration.redirect_uri,
    scope: ShopifyApp.configuration.scope
end