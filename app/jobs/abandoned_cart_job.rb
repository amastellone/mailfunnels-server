class AbandonedCartJob < ApplicationJob
  queue_as :default

  def perform(trigger_id, last_id, shop)
    shop.with_shopify_session do
      trigger = Trigger.find(trigger_id)
      if last_id == -1
        abandonedCarts = ShopifyAPI::Checkout.where(created_at_min: 2.weeks.ago, limit: 250)
      else
        abandonedCarts = ShopifyAPI::Checkout.where(since_id: last_id, limit: 250)
      end

      if abandonedCarts.first.nil? == false
        logger.info("Looking for funnel....")
        funnel = Funnel.where(app_id: trigger.app_id, trigger_id: trigger.id).first
        if funnel.nil? == false
          logger.info("Funnel found!")
          logger.info("looking for link...")
          link = Link.where(funnel_id: funnel.id, start_link: 1).first
          if link.nil? == false
            logger.info("Link found!")
            logger.info("looking for Node")
            node = Node.where(id: link.to_node_id).first
            if node.nil? == false
              logger.info("Node Found")

              abandonedCarts.each do |abandonedCart|
                if abandonedCart.email.nil? == false

                  logger.info("Checking if Subscriber exists")
                  subscriber = Subscriber.where(app_id: trigger.app_id, email: abandonedCart.email).first
                  if subscriber.nil? == true
                    logger.info("Subscriber does not exist, creating now!")
                    if abandonedCart.shipping_address.nil? == false
                      logger.info("shipping address information present")
                      first_name = abandonedCart.shipping_address.first_name
                      last_name = abandonedCart.shipping_address.last_name
                    else
                      logger.info("NO shipping address information present!")
                      first_name = null
                      last_name = null
                    end

                    subscriber = Subscriber.create(app_id: trigger.app_id,
                                                   email: abandonedCart.email,
                                                   first_name: first_name,
                                                   last_name: last_name,
                                                   revenue: 0)
                  else
                    logger.info("Subscriber exists!")
                  end

                  logger.info("Checking if subscriber is in email list")
                  emailsub = EmailListSubscriber.where(app_id: trigger.app_id,
                                                       email_list_id: funnel.email_list_id,
                                                       subscriber_id: subscriber.id).first
                  if emailsub.nil? == true
                    logger.info("Subscriber not in list, adding now!")
                    EmailListSubscriber.post('', {:app_id => trigger.app_id,
                                                  :subscriber_id => subscriber.id,
                                                  :email_list_id => funnel.email_list_id})
                  else
                    logger.info("Subscriber is already in list!")
                  end


                  logger.info "Checking if job already exists"
                  job = EmailJob.where(app_id: trigger.app_id,
                                       funnel_id: funnel.id,
                                       node_id: node.id,
                                       subscriber_id: subscriber.id).first
                  if job.nil? == true
                    logger.info("Job does not exist creating now")
                    logger.info("rendering email template for job")
                    EmailJob.post('', {:app_id => trigger.app_id,
                                       :funnel_id => funnel.id,
                                       :subscriber_id => subscriber.id,
                                       :executed => false,
                                       :node_id => node.id,
                                       :email_template_id => node.email_template_id,
                                       :sent => 0})
                    logger.info("Sent Job to database!")
                  else
                    logger.info("Email job already exists with these parameters")
                  end

                  puts "---created email job---"
                  sleep 1
                end

              end
              logger.info("All Abandoned Carts Processed!")
            end
          end
        end
      end
    end
  end
end
