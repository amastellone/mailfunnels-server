class CartsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      puts "-----Doing job------"
      #puts webhook[:id] --- how to get params from webhook response

      app = MailfunnelsUtil.get_app


      puts "----looking for subscriber----"
      subscriber = Subscriber.where(app_id: app.id, email: "FoofeeNigga@worldstarthiphop.com")
      puts "----checking for subscriber----"

      if subscriber.any? == false
        puts "----CREATED SUBSCRIBER----"
        Subscriber.create(app_id: app.id, email: "FoofeeNigga@worldstarthiphop.com")
      end


      puts "----looking for trigger----"
      trigger = Trigger.where(app_id: app.id, hook_id: '2').first
      puts "----looking for trigger----"
      if trigger.nil? == false
        puts "----Trigger Found----"

        puts "----looking for funnel----"
        funnel = Funnel.where(app_id: app.id, trigger_id: trigger.id).first
        puts "----checking for funnel----"
        if funnel.nil? == false
          puts "----Funnel Found----"
          puts funnel.id.to_s
          link = Link.where(funnel_id: funnel.id, start_link: 1).first
          if link.nil? == false
            puts "----Link Found----"
            node = link.to_node_id

            puts "----WE ARE READY TO QUEUE SIDEKIQ JOB----"
          end

        end
      end
    end
  end
end
