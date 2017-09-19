class ApplicationController < ActionController::Base
  before_action :verify_mf_integrity


  def verify_mf_integrity

    begin
      domain = params[:shop]


      if domain != nil
        puts "Domain found"
        
        app = App.where(name: domain).first
        # If no app was found, redirect to Access Denied Page
        unless app
          puts "redirecting to access_denied"
        app = App.where(name: domain).first
        # If no app was found, redirect to Access Denied Page
        unless app
          puts "--APP NOT FOUND--"
          redirect_to '/access_denied'
        end
        user = User.where(id: app.user_id).first
        unless user
          puts "--USER NOT FOUND--"
          redirect_to '/access_denied'
        end

        # Load Account Data from Infusionsoft
        begin

          @user_plan = MailFunnelsUser.get_user_plan(user.clientid)

          num_subscribers = app.subscribers.size

          limit_reached = false

          if @user_plan === -2

            remaining_subscribers = 500 - num_subscribers

            if remaining_subscribers <= 0
              limit_reached = true
            end

          end


          # if @user_plan === -99 or limit_reached
          #
          #   products = Infusionsoft.data_query('SubscriptionPlan', 100, 0, {}, [:Id, :PlanPrice])
          #
          #   product = products.select { |product| product['Id'] == 2 }[0]
          #
          #   unless product
          #
          #     response = {
          #         success: false,
          #         message: 'Error retrieving subscription plan'
          #     }
          #     # render json: response
          #
          #   end
          #
          #   price = product['PlanPrice']
          #
          #   cardId = 0
          #   current_year = Date.today.strftime('%Y')
          #   current_month = Date.today.strftime('%m')
          #   creditCardId = Infusionsoft.data_query('CreditCard',
          #                                          100,
          #                                          0,
          #                                          {'ContactId' => user.clientid, 'ExpirationYear' => '~>=~' + current_year, 'Status' => 3},
          #                                          [:Id, :ContactId, :ExpirationMonth, :ExpirationYear]
          #   ).each do |creditCard|
          #
          #     if Integer(creditCard['ExpirationYear']) == Integer(current_year)
          #       if Integer(creditCard['ExpirationMonth']) >= Integer(current_month)
          #
          #         cardId = creditCard['Id']
          #       end
          #     else
          #
          #       cardId = creditCard['Id']
          #       puts cardId
          #     end
          #   end
          #
          #   puts cardId
          #
          #   if (cardId == 0)
          #
          #     response = {
          #         success: false,
          #         message: 'Error retrieving card'
          #     }
          #     # render json: response
          #
          #   else
          #
          #     subscription_id = Infusionsoft.invoice_add_recurring_order(user.clientid, true, 2, 4, cardId, 0, 0)
          #
          #
          #     invoice_id = Infusionsoft.invoice_create_invoice_for_recurring(subscription_id)
          #
          #     upgrade_response = Infusionsoft.invoice_charge_invoice(invoice_id, "Automatic Upgrade to 1000 Subscriber Tier", cardId, 4, false)
          #
          #     if upgrade_response[:Successful]
          #       # Tag for 1000 sub tier level plan
          #       new_tier_level_tag = 106
          #
          #       # Tags to remove from user
          #       trial_ended_tag = -99
          #       failed_payment_tag = 120
          #
          #       # Remove Tags from user for failed payment and Trial ended
          #       Infusionsoft.contact_remove_from_group(user.clientid, trial_ended_tag)
          #       Infusionsoft.contact_remove_from_group(user.clientid, failed_payment_tag)
          #
          #
          #       # Add tag to user for 1000 subscribers tier level
          #       Infusionsoft.contact_add_to_group(user.clientid, new_tier_level_tag)
          #
          #
          #       response = {
          #           success: true,
          #           message: 'Subscription Added!',
          #           response: upgrade_response
          #       }
          #     else
          #       response = {
          #           success: false,
          #           message: 'Invoice charge failed',
          #           response: upgrade_response
          #       }
          #     end
          #
          #
          #
          #   end
          #
          #   render json: response and return
          #
          #
          # end

          if @user_plan === 120  or @user_plan === -99
            redirect_to '/access_denied'
          end

          # If App does not have auth_token set, update the auth token
          unless app.auth_token
            digest = OpenSSL::Digest.new('sha256')
            token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], domain)).strip
            app.put('', {
                :auth_token => token
            })
          end

        rescue => e
          redirect_to '/server_error'
        end
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
