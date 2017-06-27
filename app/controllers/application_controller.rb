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

        # Load Account Data from Infusionsoft
        contact = Infusionsoft.data_load('Contact', app.clientid, [:FirstName, :LastName, :Email, :Website, :StreetAddress1, :City, :State, :Groups])

        # Parse through Tags and look for failed payment tag
        tags = contact['Groups'].split(",")
        tags.each do |tag|

          # If contact has failed payment tag, redirect to access denied page
          if tag === '120'
            redirect_to '/access_denied'
          end
        end

        # If App does not have auth_token set, update the auth token
        unless app.auth_token
          digest = OpenSSL::Digest.new('sha256')
          token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], domain)).strip
          app.put('', {
              :auth_token => token
          })
        end

        # Update Account Info
        app.put('', {
            :first_name => contact['FirstName'],
            :last_name => contact['LastName'],
            :street_address => contact['StreetAddress1'],
            :city => contact['City'],
            :state => contact['State'],
            :client_tag => contact['Groups'],
        })

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
