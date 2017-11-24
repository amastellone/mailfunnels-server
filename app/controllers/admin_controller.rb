class AdminController < ShopifyApp::AuthenticatedController


  # Page Render Function
  # --------------------
  # Renders the Admin Panel for MailFunnels App
  # If user is an Admin, they can disable users from
  # using the app on this page
  #
  def admin_dashboard

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # If the User is not an admin redirect to error page
    if !@app.is_admin or @app.is_admin === 0
      redirect_to '/error_page'
    end


    # Otherwise get list of all Users
    @users = User.all


  end

end
