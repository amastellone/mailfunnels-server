class CartsUpdateJob < ApplicationJob
  queue_as :default

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      puts "-----Doing job------"
      #puts webhook[:id] --- how to get params from webhook response

      app = MailfunnelsUtil.get_app


      puts "----looking for subscriber----"
      subscriber = Subscriber.where(app_id: app.id, email: "FoofeeNigga@worldstarthiphop.com")

      if subscriber.any? == false
        puts "----CREATED SUBSCRIBER----"
        Subscriber.create(app_id: app.id, email: "FoofeeNigga@worldstarthiphop.com")
      end
      puts "----Subscriber Found----"

      puts "----looking for trigger----"
      trigger = Trigger.where(app_id: app.id, hook_id: '2').first
      if trigger.nil? == false
        puts "----Trigger Found----"
        puts "----incrementing num_triggered----"
        trigger.put('',:num_triggered => trigger.num_triggered+1)
        puts "----trigger saved----"
        puts "----looking for funnel----"
        funnel = Funnel.where(app_id: app.id, trigger_id: trigger.id).first
        if funnel.nil? == false
          puts "----Funnel Found----"
          puts "----looking for link----"
          link = Link.where(funnel_id: funnel.id, start_link: 1).first
          if link.nil? == false
            puts "----Link Found----"
            puts "----looking for node----"
            node = Node.where(id: link.to_node_id).first
            if node.nil? == false
              puts "----Node Found----"
              puts "----CREATING NEW EMAIL JOB----"
              puts "----MOVING SUBSCRIBER TO NEXT NODE----"
            end
          end
        end
      end
    end
  end
end
