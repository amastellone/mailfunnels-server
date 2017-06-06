class AbandonedCartJob < ApplicationJob
  queue_as :default

  def perform(trigger_id, last_id, shop, app_id)
    shop.with_shopify_session do
      trigger = Trigger.find(trigger_id)
      if last_id == -1
        abandonedCarts = ShopifyAPI::Checkout.where(created_at_min: 2.weeks.ago, limit: 250)
      else
        abandonedCarts = ShopifyAPI::Checkout.where(since_id: last_id, limit: 250)
      end

      #don't fetch all necessary entities if there are no jobs to process
      if abandonedCarts.first.nil? == false
        #process new subscribers
        subscribers = Array.new

        abandonedCarts.each do |abandonedCart|
          if abandonedCart.email.nil? == false
            logger.info("Looking for subscriber...")
            subscriber = EmailUtil.get_subscriber(abandonedCart.email, app_id)

            if subscriber
              logger.info("Subscriber found!")
              subscribers.push(subscriber)
            else
              logger.info("Subscriber does not exist, creating now")
              if abandonedCart.shipping_address.nil? == false
                logger.info("shipping address information present")
                first_name = abandonedCart.shipping_address.first_name
                last_name = abandonedCart.shipping_address.last_name
              else
                logger.info("NO shipping address information present!")
                first_name = null
                last_name = null
              end
              subscriber = EmailUtil.add_new_subscriber(abandonedCart.email,
                                                        app_id,
                                                        first_name,
                                                        last_name)
              if subscriber
                logger.info("Subscriber added")
                subscribers.push(subscriber)
              else
                logger.debug("Error adding new subscriber!")
              end
            end
          else
            logger.info("No email present")
          end
        end

        logger.info("Looking for funnel")
        funnel = EmailUtil.get_funnel(app_id, trigger.id)
        if funnel
          logger.info("Funnel found!")
        else
          logger.debug("Funnel not found!")
          return
        end

        logger.info("Looking for start link")
        link = EmailUtil.get_start_link(funnel.id)

        if link
          logger.info("Start link found!")
        else
          logger.debug("Start link not found!")
          return
        end

        logger.info("looking for Node")
        node = EmailUtil.get_node(link.to_node_id)

        if node
          logger.info("Node found!")
        else
          logger.debug("Node not found!")
          return
        end


        subscribers.each do |subscriber|
            logger.info("Checking if subscriber is in email list")
            emailsub = EmailUtil.get_email_list_subscription(app_id,
                                                             funnel.email_list_id,
                                                             subscriber.id)
            if emailsub
              logger.info("Email list subscription found!")
            else
              logger.info("No Email list subscription found!")
              emailsub = EmailUtil.add_subscriber_to_list(app_id,
                                                          funnel.email_list_id,
                                                          subscriber.id)
              if emailsub
                logger.info("Subscriber added to list")
              else
                logger.debug("Error adding subscriber to list!")
                return
              end
            end


            logger.info ("Checking if job already exists")
            if EmailUtil.does_job_exist(app_id,
                                        funnel.id,
                                        node.id,
                                        subscriber.id)
              logger.info("Jobs Already Exists")
            else
              job = EmailUtil.create_new_email_job(app_id,
                                                   funnel.id,
                                                   subscriber.id,
                                                   node.id,
                                                   node.email_template_id)
              if job
                logger.info("New Email Job Created!")
              else
                logger.debug("Error creating email job")
                return
              end
            end
            logger.info("Email job created")
            sleep 1

        end


        logger.info("All Abandoned Carts Processed!")
      end
    end
  end
end

