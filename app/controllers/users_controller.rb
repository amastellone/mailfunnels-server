class UsersController < ActionController::Base

  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the Login Page for MailFunnels
  #
  def login_page

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

    app = App.where(username: params[:mf_auth_username], password: params[:mf_auth_password]).first

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
  end

end
