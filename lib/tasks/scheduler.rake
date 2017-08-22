desc "This task is called by the Heroku scheduler add-on"


task :process_trial_accounts => :environment do
  puts "Processing Trial Users"
  User.all do |user|
  puts "1"
    plan_id  = MailFunnelsUser.get_user_plan(user.client_id)
    if plan_id == -99

      products = Infusionsoft.data_query('SubscriptionPlan', 100, 0, {}, [:Id, :PlanPrice])

      product = products.select { |product| product['Id'] == 2 }[0]

      unless product

      end
      puts "2"

      price = product['PlanPrice']

      cardId = 0
      current_year = Date.today.strftime('%Y')
      current_month = Date.today.strftime('%m')
      creditCardId = Infusionsoft.data_query('CreditCard',
                                             100,
                                             0,
                                             {'ContactId' => user.clientid, 'ExpirationYear' => '~>=~' + current_year, 'Status' => 3},
                                             [:Id, :ContactId, :ExpirationMonth, :ExpirationYear]
      ).each do |creditCard|

        if Integer(creditCard['ExpirationYear']) == Integer(current_year)
          if Integer(creditCard['ExpirationMonth']) >= Integer(current_month)

            cardId = creditCard['Id']
          end
        else

          cardId = creditCard['Id']
        end
      end
      puts "3"

      if cardId != 0

        subscription_id = Infusionsoft.invoice_add_recurring_order(user.clientid, true, 2, 4, cardId, 0, 0)


        invoice_id = Infusionsoft.invoice_create_invoice_for_recurring(subscription_id)

        upgrade_response = Infusionsoft.invoice_charge_invoice(invoice_id, "Automatic Upgrade to 1000 Subscriber Tier", cardId, 4, false)

        if upgrade_response[:Successful]
          # Tag for 1000 sub tier level plan
          new_tier_level_tag = 106

          # Tags to remove from user
          trial_ended_tag = 145
          failed_payment_tag = 120

          # Remove Tags from user for failed payment and Trial ended
          Infusionsoft.contact_remove_from_group(user.clientid, trial_ended_tag)
          Infusionsoft.contact_remove_from_group(user.clientid, failed_payment_tag)


          # Add tag to user for 1000 subscribers tier level
          Infusionsoft.contact_add_to_group(user.clientid, new_tier_level_tag)

          puts "4"

        end
        puts "5"

      end

    else
      next
    end

  end

  puts "6"




end

