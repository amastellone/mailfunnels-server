class SubscribersController < ShopifyApp::AuthenticatedController


  # USED WITH AJAX
  # --------------
  # Imports Subscribers from CSV
  #
  #
  def import_csv_subscribers

    puts "import csv"
    if request.post?
      puts "1"

      # Get Current App
      app = MailfunnelsUtil.get_app

      # If Current App does not match app_id, return error response
      unless app.id === params[:app_id].to_i
        response = {
            success: false,
            message: 'App ID does not match',
        }

        render json: response and return

      end

      # Get Subscribers JSON from params

      subscribers = Array(params[:subscribers])

      puts Array(subscribers)

      puts params[:email_list_id]


      subscribers.each do |subscriber|

        if subscriber[1][:email] and subscriber[1][:email] != ""

          new_sub = Subscriber.new

          new_sub.app_id = app.id
          new_sub.first_name = subscriber[1][:first_name]
          new_sub.last_name = subscriber[1][:last_name]
          new_sub.email = subscriber[1][:email]
          new_sub.initial_ref_type = 0
          new_sub.revenue = 0

          new_sub.save!

          unless params[:email_list_id].to_i === -1

            list_sub = EmailListSubscriber.new
            list_sub.app_id = app.id
            list_sub.email_list_id = params[:email_list_id]
            list_sub.subscriber_id = new_sub.id

            list_sub.save!
          end

        end

      end


      response = {
          success: true,
          message: 'Subscribers Imported',
      }

      render json: response

    end

  end


end
