class CartsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      puts "-----Doing job------"
      #puts webhook[:id] --- how to get params from webhook response

      app = MailfunnelsUtil.get_app

      subscriber = Subscriber.where(app_id: app.id, email: "FoofeeNigga@worldstarthiphop.com")

      if subscriber.any? == false
        puts "----CREATED SUBSCRIBER"
        Subscriber.create(app_id: app.id, email: "FoofeeNigga@worldstarthiphop.com")
      end
      hook = Hook.where(identifier: 'cart_update').first

      trigger = Trigger.where(app_id: app.id, hook_id: hook.id)
      puts "----WE ARE READY TO QUEUE SIDEKIQ JOB 2"
      if trigger.any?
        puts "----WE ARE READY TO QUEUE SIDEKIQ JOB 3"
        puts
        funnel = Funnel.where(app_id: app.id, trigger_id: trigger.id).first
        if funnel.any?
          puts "----WE ARE READY TO QUEUE SIDEKIQ JOB 4"
          puts funnel.id.to_s
          link = Link.where(funnel_id: funnel.id, start_link: 1).first
          if link.any?
            puts "----WE ARE READY TO QUEUE SIDEKIQ JOB 5"
            puts link.id.to_s
            node = link.to_node_id

            puts "----WE ARE READY TO QUEUE SIDEKIQ JOB 6"
          end

        end
      end
    end
  end
end
