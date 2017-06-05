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


    # Calculate the the total revenue for the user
    @total_revenue = 0.0

    # Loop through all funnels and sum up the total revenue
    funnels = Funnel.where(app_id: @app.id)
    funnels.each do |funnel|
      @total_revenue += funnel.num_revenue.to_f
    end

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
    @subscribers = EmailListSubscriber.where(email_list_id: params[:list_id])

    # Get all Email List
    @list = EmailList.find(params[:list_id])

    # Get all Email Templates
    @templates = EmailTemplate.where(app_id: @app.id)


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
    subscriber.revenue = 0.0


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


  # USED WITH AJAX
  # --------------
  # Removes the Subscriber and adds them to the
  # Unsubscriber list in the DB
  #
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current app we are using
  # subscriber_id: ID of the subscriber we are removing
  #
  def ajax_delete_subscriber

    # Get the Subscriber from the DB
    subscriber = Subscriber.find(params[:subscriber_id])

    # If subscriber does not exist, return error response
    if subscriber.nil?
      response = {
          success: false,
          message: 'Subscriber Does not exist in DB!'
      }
      render json: response
    end

    # Otherwise, create new Unsubscriber and Delete Subscriber
    unsubscriber = Unsubscriber.new
    unsubscriber.app_id = subscriber.app_id
    unsubscriber.first_name = subscriber.first_name
    unsubscriber.last_name = subscriber.last_name
    unsubscriber.email = subscriber.email

    # If error saving unsubscriber, then return error response
    if !unsubscriber.save!
      response = {
          success: false,
          message: 'Could not save unsubscriber!'
      }
      render json: response
    end

    # Now remove the Subscriber from DB
    subscriber.destroy

    # Return Success Response
    response = {
        success: true,
        message: 'Subscriber Deleted!'
    }
    render json: response

  end




  # USED WITH AJAX
  # --------------
  # Sends a batch email to all subscribers on that list
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current App
  # email_template_id: ID of the Email Template to send to subscribers
  # email_list_id: ID of the email list to send batch email to
  #
  def ajax_create_batch_email

    # Create new Batch Email
    batch = BatchEmailJob.new

    # Update the Attributes for the Batch Email Jon
    batch.app_id = params[:app_id]
    batch.email_template_id = params[:email_template_id]
    batch.email_list_id = params[:email_list_id]

    if batch.save!
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


  def ajax_load_time_data

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Date Values
    today = Time.now
    oneDay = Time.now - 1.day
    week = Time.now - 7.days
    month = Time.now - 30.days

    #todaysSubscribers = Subscriber.where(app_id: @app.id, created_at: 1.day.ago..Time.now).size
    #weeksSubscribers = Subscriber.where(app_id: @app.id,["created_at >= ?", week]).count
    #monthSubscribers = Subscriber.where(app_id: @app.id,["created_at >= ?", month]).count
    #emailJob = EmailJob.where(app_id: @app.id)
    emails_sent = EmailJob.where(app_id: @app.id, sent: 1)
    emails_opened = EmailJob.where(app_id: @app.id, opened: 1)
    emails_clicked = EmailJob.where(app_id: @app.id, clicked: 1)

    data = {
        #:todaysSubscribers => todaysSubscribers,
        #:weeksSubscribers => weeksSubscribers,
        #:monthsSubsribers => monthSubscribers,
        # :subscribers => subscribers.all,
        # :subscribers_created_date => subscribers.created_at,
        # :emailJob_created_date => emailJob.created_at,
        # :emails_sent => emails_sent.all,
        # :emails_opened => emails_opened.all,
        # :emails_clicked => emails_clicked.all,
    }


    # Return data as JSON
    render json: data


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
