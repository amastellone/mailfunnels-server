require 'csv'
require 'date'

class MainInterfaceController < ShopifyApp::AuthenticatedController

  # Page Render Function
  # --------------------
  # Renders the Home Page of the MailFunnels App
  #
  #
  def index

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # If the User is not an admin redirect to error page
    if @app.is_disabled and @app.is_disabled === 1
      redirect_to '/account_disabled' and return
    end

    user = @app.user

    @user_plan = MailFunnelsUser.get_user_plan(user.clientid)

    # If cancellation request tag is found, remove other tags and disable app
    if @user_plan === 171

      status = MailFunnelsUser.process_account_cancellation(user.clientid)

      puts "Status: #{status}"

      @app.put('', {
          :is_disabled => 1
      })

      redirect_to '/account_disabled' and return

    end

    @subs_left = MailFunnelsUser.get_remaining_subs(user.clientid)

    @num_email_sent = EmailJob.where(app_id: @app.id, sent: 1).size

    @num_email_opened = EmailJob.where(app_id: @app.id, opened: 1).size

    @num_email_clicked = EmailJob.where(app_id: @app.id, clicked: 1).size

    # Get all Email Templates For App
    @num_templates = EmailTemplate.where(app_id: @app.id, is_archived: 0).size


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
  def all_refund_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get all subscribers instances for the app
    @subscribers = Subscriber.where(app_id: @app.id, initial_ref_type: 2)

    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)

  end

  # Page Render Function
  # --------------------
  # Renders the All Subscribers Page which
  # contains a table of all subscribers on for the
  # current app
  #
  def all_abandoned_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get all subscribers instances for the app
    @subscribers = Subscriber.where(app_id: @app.id, initial_ref_type: 3)

    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)

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



    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)


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

    # Get all Funnels associated with current email list
    @funnels = Funnel.where(email_list_id: params[:list_id])

    # Get number of broadcast lists associated with current email list
    @num_broadcasts = BroadcastList.where(email_list_id: params[:list_id]).size



    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)




  end


  # Page Render Function
  # --------------------
  # Renders the Error Page for when user tries to
  # access the admin panel and is not an admin
  #
  #
  def error_page

    #Get the Current App
    @app = MailfunnelsUtil.get_app

  end

  # Page Render Function
  # --------------------
  # Renders the Account Disabled Page
  #
  #
  def account_disabled

  end


  # Page Render Function
  # --------------------
  # Renders the Trial User access denied page
  #
  #
  def trial_page_disabled

    #Get the Current App
    @app = MailfunnelsUtil.get_app

  end


  # Page Render Function
  # --------------------
  # Renders the Account page of the MailFunnels App
  #
  #
  def account

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get Current MailFunnels Plan For User
    @plan = MailFunnelsUser.get_user_plan(@app.user.clientid)

    # Get The Current User
    @user = @app.user

    @app = MailfunnelsUtil.get_app


  end


  # Page Render Function
  # --------------------
  # Renders the Support Page which contains link
  # to MailFunnels Support and youtube videos which
  # show users how to use features
  #
  def support

    # Get the Current App
    @app = MailfunnelsUtil.get_app

  end


  def ajax_update_account_info

    # Get the current App
    app = App.find(params[:id])

    # If no app
    unless app
      response = {
          success: false,
          message: 'App not found!'
      }

      render json: response and return
    end

    # Get Current User
    user = app.user

    # Change User Info in DB
    user.put('', {
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :email => params[:email]
    })

    # Update Infusionsoft Contact
    Infusionsoft.contact_update(user.clientid, {
        :FirstName => params[:first_name],
        :LastName => params[:last_name],
        :Email => params[:email]
    })

    response = {
        success: true,
        message: 'User Updated!'
    }

    render json: response


  end


  def ajax_update_email_info

    # Access current app
    app = App.find(params[:id])
    # user = User.find(app.user_id)

    unless app
      response = {
          success: false,
          message: 'App not found'
      }

      render json: response and return

    end

    app.put('', {
        :from_name => params[:from_name],
        :email_def_color => params[:email_def_color],
        :show_mf_powered => params[:show_mf_powered],
        :foot_use_bill_add => params[:foot_use_bill_add],
        :foot_street => params[:foot_street],
        :foot_city => params[:foot_city],
        :foot_state => params[:foot_state],
        :foot_zip => params[:foot_zip]
    })

    # user.put('', {
    #     :has_mailfunnel_watermark => params[:watermark]
    # })


    response = {
        success: true,
        message: 'From Name Successflully Set'
    }

    # Return JSON response
    render json: response
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

    # Get Current App
    app = App.find(params[:app_id])

    # If no app found return error response
    unless app
      response = {
          success: false,
          type: -1,
          message: 'Could not find current App'
      }
      render json: response and return
    end

    # Get Current User Remaining Subs
    subs_remaining = MailFunnelsUser.get_remaining_subs(app.user.clientid)

    # If no more subscribers left in plan, return error response
    if subs_remaining < 1
      response = {
          success: false,
          type: 0,
          message: 'No more subscribers left'
      }
      render json: response and return
    end


    # Create new Subscriber instance
    subscriber = Subscriber.new

    # Update the Attributes for the Subscriber
    subscriber.app_id = params[:app_id]
    subscriber.first_name = params[:first_name]
    subscriber.last_name = params[:last_name]
    subscriber.email = params[:email]
    subscriber.initial_ref_type = 0
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
    email_list_subscriber = EmailListSubscriber.where(subscriber_id: subscriber.id).first

    # Otherwise, create new Unsubscriber and Delete Subscriber
    unsubscriber = Unsubscriber.new
    unsubscriber.app_id = subscriber.app_id
    unsubscriber.first_name = subscriber.first_name
    unsubscriber.last_name = subscriber.last_name
    unsubscriber.email = subscriber.email
    unsubscriber.initial_ref_type = subscriber.initial_ref_type
    if !email_list_subscriber.nil?
      unsubscriber.email_list_id = email_list_subscriber.email_list_id
    end


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

  def ajax_remove_from_list
    subscriber = Subscriber.find(params[:subscriber_id])
    list = EmailList.find(params[:email_list_id])
    list_subscriber = EmailListSubscriber.where(subscriber_id: subscriber.id, email_list_id: list.id).first


    if list_subscriber
      list_subscriber.destroy
    end


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

    # Subscriber Values
    today_subscribers = Subscriber.where(app_id: @app.id, day: 1).size
    week_subscribers = Subscriber.where(app_id: @app.id, week: 1).size
    month_subscribers = Subscriber.where(app_id: @app.id, month: 1).size

    # Unsubscriber Values
    today_unsubscribers = Unsubscriber.where(app_id: @app.id, day: 1).size
    week_unsubscribers = Unsubscriber.where(app_id: @app.id, week: 1).size
    month_unsubscribers = Unsubscriber.where(app_id: @app.id, month: 1).size

    # Emails Sent Values
    today_emails_sent = EmailJob.where(app_id: @app.id, sent: 1, day: 1).size
    week_emails_sent = EmailJob.where(app_id: @app.id, sent: 1, week: 1).size
    month_emails_sent = EmailJob.where(app_id: @app.id, sent: 1, month: 1).size

    # Emails Opened Values
    today_emails_opened = EmailJob.where(app_id: @app.id, opened: 1, day: 1).size
    week_emails_opened = EmailJob.where(app_id: @app.id, opened: 1, week: 1).size
    month_emails_opened = EmailJob.where(app_id: @app.id, opened: 1, month: 1).size

    # Emails Clicked Values
    today_emails_clicked = EmailJob.where(app_id: @app.id, clicked: 1, day: 1).size
    week_emails_clicked = EmailJob.where(app_id: @app.id, clicked: 1, week: 1).size
    month_emails_clicked = EmailJob.where(app_id: @app.id, clicked: 1, month: 1).size

    # Revenue Stats
    today_revenue = 0
    week_revenue = 0
    month_revenue = 0
    CapturedHook.where(app_id: @app.id, day: 1).each do |hook|
      today_revenue = today_revenue + hook.revenue.to_f
    end
    CapturedHook.where(app_id: @app.id, week: 1).each do |hook|
      week_revenue = week_revenue + hook.revenue.to_f
    end
    CapturedHook.where(app_id: @app.id, month: 1).each do |hook|
      month_revenue = month_revenue + hook.revenue.to_f
    end


    data = {
        today_subscribers: today_subscribers,
        week_subscribers: week_subscribers,
        month_subscribers: month_subscribers,
        today_unsubscribers: today_unsubscribers,
        week_unsubscribers: week_unsubscribers,
        month_unsubscribers: month_unsubscribers,
        today_emails_sent: today_emails_sent,
        week_emails_sent: week_emails_sent,
        month_emails_sent: month_emails_sent,
        today_emails_opened: today_emails_opened,
        week_emails_opened: week_emails_opened,
        month_emails_opened: month_emails_opened,
        today_emails_clicked: today_emails_clicked,
        week_emails_clicked: week_emails_clicked,
        month_emails_clicked: month_emails_clicked,
        today_revenue: ActionController::Base.helpers.number_to_currency(today_revenue),
        week_revenue: ActionController::Base.helpers.number_to_currency(week_revenue),
        month_revenue: ActionController::Base.helpers.number_to_currency(month_revenue),

    }


    # Return data as JSON
    render json: data


  end


  # USED WITH AJAX
  # --------------
  # Shows Info Pertaining to subscriber
  #
  # PARAMETERS
  # ----------
  # ID: ID of the subscriber
  # first_name: First name of the subscriber
  # last_name: Last name of the subscriber
  # email: Email of the subscriber
  # revenue: Revenue from the subscriber
  #

  def ajax_load_subscriber_info

    # Get the Subscriber from list
    subscriber = Subscriber.find(params[:subscriber_id])
    subscriber_emails = EmailJob.where(subscriber_id: params[:subscriber_id])
    email_lists = EmailListSubscriber.where(subscriber_id: params[:subscriber_id])

    email_list = Array.new
    temp = Array.new

    subscriber_emails.each do |se|
      email = {
          :email_id => se.id,
          :name => se.email_template.name,
          :clicked => se.clicked,
          :opened => se.opened,
      }

      temp.push(email)

    end

    email_lists.each do |el|
      list = {
          :email_list_id => el.email_list_id,
          :email_list_name => el.email_list.name,
      }

      email_list.push(list)
    end

    data = {

        :id => subscriber.id,
        :first_name => subscriber.first_name,
        :last_name => subscriber.last_name,
        :email => subscriber.email,
        :revenue => subscriber.revenue,
        :total_emails => subscriber_emails.size,
        :emails => temp.to_json,
        :total_lists => email_lists.size,
        :lists => email_list.to_json,

    }

    # Return data as JSON
    render json: data

  end


  # USED WITH AJAX
  # --------------
  # Enables the app if the user is an admin
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the app that we are enabling
  #
  def ajax_enable_app

    # Get the Current App
    current_app = MailfunnelsUtil.get_app

    # If the User is not an admin return error response
    if !current_app.is_admin or current_app.is_admin === 0
      response = {
          success: false,
          message: 'You do not have admin privileges!'
      }
      render json: response
    end

    # Get the App we are disabling
    app = App.find(params[:app_id])

    # Set disables status to 0
    app.is_disabled = 0

    app.put('', {
        :is_disabled => app.is_disabled,
    })


    # Return Success Response
    response = {
        success: true,
        message: 'App Enabled!'
    }
    render json: response


  end

  def ajax_upgrade_plan

    @app = MailfunnelsUtil.get_app
    user = User.find(@app.user_id)
    puts "-----1-----"
    puts user


    plan = MailFunnelsUser.get_user_plan(user.clientid)
    puts "2"
    recurring_orders = Infusionsoft.data_query('RecurringOrderWithContact', 100, 0, {}, [:Id, :ContactId])
    puts "3"

    recurring = recurring_orders.select {|recurring| recurring['ContactId'] == user.clientid}[0]

    order = recurring['Id']
    puts "Recurring Order ID: #{order}"


    puts "4"


    plan_id  = MailFunnelsUser.get_user_plan(user.clientid)

    products = Infusionsoft.data_query('SubscriptionPlan', 100, 0, {}, [:Id, :PlanPrice])

    product = products.select { |product| product['Id'] == params[:subscription_id].to_i }[0]


    unless product
      response = {
          success: false,
          message: 'Error retrieving subscription plan'
      }
      render json: response
    end

    price = product['PlanPrice']

    creditCardId = Infusionsoft.invoice_locate_existing_card(user.clientid, params[:last_four])

    if (creditCardId == 0)
      response = {
          success: false,
          message: 'Error retrieving card'
      }
      render json: response
    end




    invoice = Infusionsoft.invoice_add_subscription(user.clientid,
                                                    false,
                                                    params[:subscription_id],
                                                    1,
                                                    price,
                                                    false,
                                                    4,
                                                    creditCardId,
                                                    0,
                                                    0
    )







    tag = -1

    if params[:subscription_id].to_i == 2
      tag=106
    elsif params[:subscription_id].to_i == 4
      tag=108

    elsif params[:subscription_id].to_i == 6
      tag=110

    elsif params[:subscription_id].to_i == 8
      tag=112

    elsif params[:subscription_id].to_i == 10
      tag=114

    elsif params[:subscription_id].to_i == 12
      tag=116

    elsif params[:subscription_id].to_i == 14
      tag=118
    end

    Infusionsoft.contact_remove_from_group(user.clientid, plan)


    puts "--------------TEST---------------"

    Infusionsoft.contact_add_to_group(user.clientid, tag)
    Infusionsoft.contact_remove_from_group(user.clientid, plan_id)


    Infusionsoft.invoice_delete_subscription(order)

    response = {
        success: true,
        message: 'Subscription Added!'
    }

    render json: response

  end


  # USED WITH AJAX
  # --------------
  # Disables the app if the user is an admin
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the app that we are disabling
  #
  def ajax_disable_app

    # Get the Current App
    current_app = MailfunnelsUtil.get_app

    # If the User is not an admin return error response
    if !current_app.is_admin or current_app.is_admin === 0
      response = {
          success: false,
          message: 'You do not have admin privileges!'
      }
      render json: response
    end

    # Get the App we are disabling
    app = App.find(params[:app_id])

    # Set disables status to 1
    app.is_disabled = 1

    app.put('', {
        :is_disabled => app.is_disabled,
    })


    # Return Success Response
    response = {
        success: true,
        message: 'App Disabled!'
    }
    render json: response


  end

  def ajax_add_to_list
    subscriber = EmailListSubscriber.new

    subscriber.app_id = params[:app_id]
    subscriber.email_list_id = params[:list_id]
    subscriber.subscriber_id = params[:subscriber_id]

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
  # Changes the users password
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the Current App
  # password: New Password
  #
  def ajax_change_password

    # Get the current App
    app = App.find(params[:app_id])

    # If no app
    unless app
      response = {
          success: false,
          message: 'App not found!'
      }

      render json: response and return
    end

    # Get Current User
    user = app.user

    # Change User Password in DB
    user.password = params[:password]

    # Update Infusionsoft Contact
    Infusionsoft.contact_update(user.clientid, {
        :Password => params[:password]
    })

    # Save User to DB
    user.save

    response = {
        success: true,
        message: 'Password Updated!'
    }

    render json: response
  end

  def ajax_save_edited_list_info
    list = EmailList.find(params[:list_id])

    list.name = params[:name]
    list.description = params[:description]

    list.put('', {
        :name => list.name,
        :description => list.description,
    })
    # Return Success Response
    response = {
        success: true,
        message: 'List Updated!'
    }
    render json: response


  end

  def ajax_delete_email_list



    # Get the list from the database
    list = EmailList.find(params[:list_id])

    # Get subscribers that belong to current Email List
    list_subscriber = EmailListSubscriber.where(email_list_id: list.id)


    list_subscriber.each do |subscriber|

      global_subscriber = Subscriber.find(subscriber.subscriber_id)

      global_subscriber.destroy

    end


    list.put('', {
        :active => 1
    })


  end


  def ajax_mf_cancel_account

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get User and add cancellation request tag
    user = @app.user
    Infusionsoft.contact_add_to_group(user.clientid, 171)

    # Get User Plan to confirm cancellation request went through
    @user_plan = MailFunnelsUser.get_user_plan(user.clientid)

    # If cancellation request tag is found, remove other tags and cancel account
    if @user_plan === 171

      status = MailFunnelsUser.process_account_cancellation(user.clientid)

      @app.put('', {
          :is_disabled => 1
      })

      response = {
          success: true,
          message: 'Account Cancelled!'
      }
      render json: response and return

    end

    response = {
        success: false,
        message: 'Account Not Cancelled!'
    }
    render json: response

  end

  def account_cancelled

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
