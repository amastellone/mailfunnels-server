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

      app = App.where(clientid: contact.first['ID']).first

      if !app
        # Return Error Response
        response = {
            success: false,
            message: 'Authentication Failed'
        }

        render json: response
      end

      # Return Json Response with shopify domain
      response = {
          success: true,
          url: app.name,
          message: 'Authentication Failed'
      }

      render json: response

    else

      # Return Error Response
      response = {
          success: false,
          message: 'Authentication Failed'
      }

      render json: response

    end


  end


end
