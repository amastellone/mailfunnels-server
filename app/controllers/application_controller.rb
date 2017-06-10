class ApplicationController < ActionController::Base
  before_action :install_server_app
  protect_from_forgery


  def install_server_app

    begin
      logger.info(params.to_s)
      domain = params[:shop]

      if domain != nil
        logger.info("HERE2")

        server_app = App.where(name: domain)

        if server_app.any? == false
          logger.info("HERE3")

          digest = OpenSSL::Digest.new('sha256')
          token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], domain)).strip
          server_app = App.create(name: domain, auth_token: token)
        end
      end
    end


  rescue => e
    logger.error e.message
  end

  helper_method :current_shop, :shopify_session

  private

  def current_shop
    logger.info("HERE4")

    @current_shop ||= Shop.find(session[:shop_id]) if session[:shop_id].present?
  end

  def shopify_session
    unless current_shop.nil?
      logger.info("HERE5")

      api_key = Rails.configuration.shopify_api_key
      token   = current_shop.token
      domain  = current_shop.domain

      ShopifyAPI::Base.site = "https://#{api_key}:#{token}@#{domain}/admin"
    end

    yield

  ensure ShopifyAPI::Base.site = nil
  end

end
