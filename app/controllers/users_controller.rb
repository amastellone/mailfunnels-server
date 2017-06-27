class UsersController < ActionController::Base

  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the Login Page for MailFunnels
  #
  def login_page

  end


  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the account disabled page
  #
  def access_denied

  end


  # POST ROUTE
  # ----------
  # Creates a new App Instance
  # Used with infusionsoft to create new account
  # upon app order form submit
  #
  # PARAMETERS
  # ----------
  # client_id: Infusionsoft Client ID
  # first_name: First Name of the User
  # last_name: Last Name of the User
  # email: Email Address of the User
  # username: Username of the User
  # password: Password of the User
  # shop_domain: Shopify Domain of the User
  #
  def mf_api_user_create

    app = App.new

    app.first_name = params[:first_name]
    app.last_name = params[:last_name]
    app.name = params[:shop_domain]
    app.email = params[:email]
    app.username = params[:username]
    app.password = params[:password]
    app.clientid = params[:client_id]

    app.save

    # Return Success Response
    response = {
        success: true,
        message: 'Account Created'
    }

    render json: response


  end


  # USED WITH AJAX
  # --------------
  # Authenticates the user and redirects to shopify auth
  #
  # PARAMETERS
  # ----------
  # mf_auth_username: Username of the user
  # mf_auth_password: Password of the user
  #
  def ajax_mf_user_auth

    # Get User Information from Infusionsoft
    contact = Infusionsoft.contact_find_by_email(params[:mf_auth_username], [:ID, :Password])

    if contact.first['Password'] === params[:mf_auth_password]

      user = User.where(clientid: contact.first['ID']).first

      unless user
        # Return Error Response
        response = {
            success: false,
            message: 'Authentication Failed'
        }

        render json: response
      end

      # Look for App for the User
      app = App.where(user_id: user.id).first

      logger.info app


      if app

        # Return Json Response with shopify domain
        response = {
            success: true,
            type: 2,
            url: app.name,
            message: 'Authentication Passed'
        }

        render json: response

      else

        response = {
            success: true,
            type: 1,
            user_id: user.id,
            url: 'none',
            message: 'User has not configured Shopify Domain yet.'
        }
        render json: response
      end



    else

      # Return Error Response
      response = {
          success: false,
          message: 'Authentication Failed'
      }

      render json: response

    end
  end


  # USED WITH AJAX
  # --------------
  # Creates a new App for the User
  #
  # PARAMETERS
  # ----------
  # user_id: ID of the User to create App For
  # domain: Shopify Domain to install the App with
  #
  def ajax_mf_app_create

    domain = params[:domain] + ".myshopify.com"

    digest = OpenSSL::Digest.new('sha256')
    token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], params[:domain])).strip
    app = App.create(user_id: params[:user_id], name: domain, auth_token: token)

    response = {
        success: true,
        url: app.name,
        message: 'App Created!'
    }

    render json: response

  end


end
