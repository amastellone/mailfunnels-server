class MainInterfaceController < ShopifyApp::AuthenticatedController

  # Page Render Function
  # --------------------
  # Renders the Home Page of the MailFunnels App
  #
  #
  def index

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    @num_email_sent = EmailJob.where(app_id: @app.id, sent: 1).size

    @num_email_opened = EmailJob.where(app_id: @app.id, opened: 1).size

    @num_email_clicked = EmailJob.where(app_id: @app.id, clicked: 1).size

  end


  # Page Render Function
  # --------------------
  # Renders the All Subscribers Page which
  # contains a table of all subscribers on for the
  # current app
  #
  def all_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get all subscribers instances for the app
    @subscribers = Subscriber.where(app_id: @app.id)

  end


  # Page Render Function
  # --------------------
  # Renders the List Subscribers Page which
  # contains a table of all the subscribers on the
  # list provided by id in params
  #
  # PARAMETERS
  # ----------
  # list_id: ID of the list we want to display subscribers for
  #
  def list_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get the current list
    @list = EmailList.find(params[:list_id])

  end


  # USED WITH AJAX
  # --------------
  # Creates a new subscribers for the app
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current app
  # first_name: First Name of the Subscriber
  # last_name: Last Name of the Subscriber
  # email: Email address of the Subscriber
  #
  def ajax_create_subscriber

    # Create new Subscriber instance
    subscriber = Subscriber.new

    # Update the Attributes for the Subscriber
    subscriber.app_id = params[:app_id]
    subscriber.first_name = params[:first_name]
    subscriber.last_name = params[:last_name]
    subscriber.email = params[:email]


    # Save and verify Subscriber and return correct JSON response
    if subscriber.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json

  end

  def form_page
    if request.post?
      if params[:name].present?
        flash[:notice] = "Created #{ params[:colour] } unicorn: #{ params[:name] }."
      else
        flash[:error] = "Name must be set."
      end
    end
  end

  def pagination
    @total_pages = 3
    @page = (params[:page].presence || 1).to_i
    @previous_page = "/pagination?page=#{ @page - 1 }" if @page > 1
    @next_page = "/pagination?page=#{ @page + 1 }" if @page < @total_pages
  end

end
