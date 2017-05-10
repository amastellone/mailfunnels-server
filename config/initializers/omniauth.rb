Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shopify,
    ShopifyApp.configuration.api_key,
    ShopifyApp.configuration.secret,
       :redirect_uri => "http://localhost:3000/auth/shopify/callback",
       # :callback_url => ShopifyApp.configuration.redirect_uri,
    scope: ShopifyApp.configuration.scope
end