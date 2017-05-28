class CartsUpdateJob < ApplicationJob
  queue_as :default

  def get_binding
    binding
  end

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
  #     puts "-----Doing job------"
  #     #puts webhook[:id] --- how to get params from webhook response
  #
  #     app = MailfunnelsUtil.get_app
  #
  #
  #     subscriber = Subscriber.where(app_id: app.id, email: "ayylmao@worldstarthiphop.com").first
  #
  #
  #     if subscriber.nil? == true
  #       puts "----CREATED SUBSCRIBER----"
  #       subscriber = Subscriber.create(app_id: app.id, email: "ayylmao@worldstarthiphop.com")
  #     else
  #       puts "----NOT CREATING SUBSCRIBER----"
  #     end
  #     puts ""
  #     trigger = Trigger.where(app_id: app.id, hook_id: '2').first
  #     if trigger.nil? == false
  #       trigger.put('', :num_triggered => trigger.num_triggered+1)
  #
  #       funnel = Funnel.where(app_id: app.id, trigger_id: trigger.id).first
  #       if funnel.nil? == false
  #
  #         puts "----checking if subscribers is in email list----"
  #         emailsub = EmailListSubscriber.where(app_id: app.id, email_list_id: funnel.email_list_id, subscriber_id: subscriber.id).first
  #         if emailsub.nil? == true
  #           puts "----ADDED SUBSCRIBER TO EMAIL LIST----"
  #           EmailListSubscriber.post('', {:app_id => app.id, :subscriber_id => subscriber.id, :email_list_id => funnel.email_list_id})
  #         else
  #           puts "----NOT ADDING SUBSCRIBER TO EMAIL LIST----"
  #         end
  #         puts ""
  #         link = Link.where(funnel_id: funnel.id, start_link: 1).first
  #         if link.nil? == false
  #
  #           node = Node.where(id: link.to_node_id).first
  #           if node.nil? == false
  #             node.put('', :num_emails => node.num_emails+1)
  #             emailjob = EmailJob.where(app_id: app.id, funnel_id: funnel.id, node_id: node.id, subscriber_id: subscriber.id).first
  #             if emailjob.nil? == true
  #               puts "----CREATING NEW EMAIL JOB----"
  #               EmailJob.post('', {:app_id => app.id, :funnel_id => funnel.id, :subscriber_id => subscriber.id, :executed => false, :node_id => node.id, :email_template_id => node.email_template_id, :sent => 0})
  #             else
  #               puts "----NOT CREATING NEW EMAIL JOB----"
  #             end
  #             puts "----MOVING SUBSCRIBER TO NEXT NODE----"
  #
  #           end
  #         end
  #       end
  #     end
    end
  end

end