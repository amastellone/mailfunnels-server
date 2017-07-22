class ApplicationController < ActionController::Base
  before_action :verify_mf_integrity


  def verify_mf_integrity

    begin
      domain = params[:shop]

      if domain != nil

        app = App.where(name: domain).first

        # If no app was found, redirect to Access Denied Page
        unless app
          redirect_to '/access_denied'
        end

        user = app.user

        # Load Account Data from Infusionsoft

        begin

          @user_plan = MailFunnelsUser.get_user_plan(user.clientid)

          if @user_plan === 120  or @user_plan === -99
            redirect_to '/access_denied'
          end

          # If App does not have auth_token set, update the auth token
          unless app.auth_token
            digest = OpenSSL::Digest.new('sha256')
            token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], domain)).strip
            app.put('', {
                :auth_token => token
            })
          end

        rescue => e
          redirect_to '/server_error'
        end
      end
    end



  end


  helper_method :current_shop, :shopify_session

  private

  def current_shop

    @current_shop ||= Shop.find(session[:shop_id]) if session[:shop_id].present?
  end

  def shopify_session
    unless current_shop.nil?

      api_key = Rails.configuration.shopify_api_key
      token   = current_shop.token
      domain  = current_shop.domain

      ShopifyAPI::Base.site = "https://#{api_key}:#{token}@#{domain}/admin"
    end

    yield

  ensure ShopifyAPI::Base.site = nil
  end

end
