require 'httparty'

class ApplicationController < ActionController::Base
  attr_reader :tokens
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session

  # TODO Security - Enable forgery protection in controller that was temp. disabled for AJAX Calls
  protect_from_forgery with: :exception

  API_KEY = "caa193ae7beecf2475567f5b2c8bef72"
  API_SECRET = "0622e20a492275f6e4f2b23b9a139000"
  APP_URL = "a55bda40.ngrok.io"


  def initialize
    @tokens = {}
    super
  end

  def activate_session
    ShopifyAPI::Base.activate_session(session)
  end


  # MailFunnels Shopify App Store Install route
  #
  # Called after the login page form is submitted
  #
  def mailfunnels_install

    shop = request.params['shop']
    scopes = "read_orders,read_products,write_products"

    # construct the installation URL and redirect the merchant
    install_url = "http://#{shop}/admin/oauth/authorize?client_id=#{API_KEY}"\
                "&scope=#{scopes}&redirect_uri=https://#{APP_URL}/mailfunnels_auth"

    # redirect to the install_url
    redirect_to install_url

  end



  def mailfunnels_auth

    # extract shop data from request parameters
    shop = request.params['shop']
    code = request.params['code']
    hmac = request.params['hmac']

    # perform hmac validation to determine if the request is coming from Shopify
    validate_hmac(hmac,request)

    # if no access token for this particular shop exist,
    # POST the OAuth request and receive the token in the response
    get_shop_access_token(shop,API_KEY,API_SECRET,code)

    # create webhook for order creation if it doesn't exist
    create_order_webhook

    # now that the session is activated, redirect to the bulk edit page
    redirect_to "https://#{APP_URL}/order_create_webhook"


      # begin
      #   domain = params[:shop]
      #
      #   if domain != nil
      #     server_app = App.where(name: domain)
      #
      #     if server_app.any? == false
      #       digest = OpenSSL::Digest.new('sha256')
      #       token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], domain)).strip
      #       server_app = App.create(name: domain, auth_token: token)
      #     end
      #   end
      # end

  end


  private
  def order_create_webhook
    # inspect hmac value in header and verify webhook
    hmac = request.env['HTTP_X_SHOPIFY_HMAC_SHA256']

    request.body.rewind
    data = request.body.read
    webhook_ok = verify_webhook(hmac, data)

    if webhook_ok
      shop = request.env['HTTP_X_SHOPIFY_SHOP_DOMAIN']
      token = @tokens[shop]

      unless token.nil?
        session = ShopifyAPI::Session.new(shop, token)
        ShopifyAPI::Base.activate_session(session)
      else
        return [403, "You're not authorized to perform this action."]
      end
    else
      return [403, "You're not authorized to perform this action."]
    end

    # parse the request body as JSON data
    json_data = JSON.parse data

    line_items = json_data['line_items']

    line_items.each do |line_item|
      variant_id = line_item['variant_id']

      variant = ShopifyAPI::Variant.find(variant_id)

      variant.metafields.each do |field|
        if field.key == 'ingredients'
          items = field.value.split(',')

          items.each do |item|
            gift_item = ShopifyAPI::Variant.find(item)
            gift_item.inventory_quantity = gift_item.inventory_quantity - 1
            gift_item.save
          end
        end
      end
    end

    return [200, "Webhook notification received successfully."]
  end


  def get_shop_access_token(shop,client_id,client_secret,code)
    if @tokens[shop].nil?
      url = "https://#{shop}/admin/oauth/access_token"

      payload = {
          client_id: client_id,
          client_secret: client_secret,
          code: code}

      response = HTTParty.post(url, body: payload)
      # if the response is successful, obtain the token and store it in a hash
      if response.code == 200
        @tokens[shop] = response['access_token']
      else
        return [500, "Something went wrong."]
      end

      instantiate_session(shop)
    end
  end

  def instantiate_session(shop)
    # now that the token is available, instantiate a session
    session = ShopifyAPI::Session.new(shop, @tokens[shop])
    ShopifyAPI::Base.activate_session(session)
    puts "shopify session activated"
  end

  def validate_hmac(hmac,request)
    h = request.params.reject{|k,_| k == 'hmac' || k == 'signature'}
    query = URI.escape(h.sort.collect{|k,v| "#{k}=#{v}"}.join('&'))
    digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), API_SECRET, query)

    unless (hmac == digest)
      return [403, "Authentication failed. Digest provided was: #{digest}"]
    end
  end

  def verify_webhook(hmac, data)
    digest = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, API_SECRET, data)).strip

    hmac == calculated_hmac
  end


  def create_order_webhook
    puts "creating order webhook...."
    # create webhook for order creation if it doesn't exist
    unless ShopifyAPI::Webhook.find(:all).any?
      webhook = {
          topic: 'orders/create',
          address: "https://#{APP_URL}/order_create_webhook",
          format: 'json'}

      ShopifyAPI::Webhook.create(webhook)
    end
  end

end
