class RefundsCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    logger.info("Doing Refund Job")
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      app = MailfunnelsUtil.get_app
      logger.info("Finding order #{webhook[:order_id]}")
      order = ShopifyAPI::Order.find(:all, :params => {:limit => 1, :id => webhook[:order_id]}).first
      if order.nil? == false
        logger.info("Order found!")

        logger.info("Checking if subscriber #{order.email} exists")
        subscriber = EmailUtil.get_subscriber(order.email, app.id)

        if subscriber
          logger.info("Subscriber found!")
          logger.info("Decrementing Subscriber revenue...")
          subscriber.put('',:revenue => subscriber.revenue.to_f-webhook[:subtotal_price].to_f)
        else
          logger.info("Subscriber does not exist, creating now")
          subscriber = EmailUtil.add_new_subscriber(order.email,
                                                    app.id,
                                                    order.billing_address.first_name,
                                                    order.billing_address.last_name,
                                                    2
          )

          if subscriber
            logger.info("Subscriber added")
          else
            logger.debug("Error adding new subscriber!")
            return
          end
        end

        logger.info("Looking for corresponding hook...")
        hook = EmailUtil.get_hook('refund_create')

        if hook
          logger.info("Hook found!")
        else
          logger.debug("Hook not found!")
          return
        end

        trigger = nil

        order.line_items.each do |product|
          trigger = EmailUtil.get_trigger_product(app.id, hook.id, product.product_id)
          if trigger
            logger.info("product trigger found")
            trigger = EmailUtil.increment_trigger_hit_count(trigger)
            break
          end
        end


        unless trigger
          logger.info("general trigger found")
          trigger = EmailUtil.get_trigger(app.id, hook.id)
          trigger = EmailUtil.increment_trigger_hit_count(trigger)
        end


          if trigger

          logger.info("Looking for funnel")
          funnel = EmailUtil.get_funnel(app.id, trigger.id)
          if funnel
            logger.info("Funnel found!")
            logger.info("Incrementing Funnel revenue...")
            funnel = EmailUtil.increase_funnel_revenue(funnel, webhook[:subtotal_price].to_f)
            if funnel
              logger.info("Funnel updated!")
            else
              logger.debug("Error increasing funnel revenue")
              return
            end

          else
            logger.debug("Funnel not found!")
            return
          end


          emailsub = EmailUtil.get_email_list_subscription(app.id,
                                                           funnel.email_list_id,
                                                           subscriber.id)
          if emailsub
            logger.info("Email list subscription found!")
          else
            logger.info("No Email list subscription found!")
            emailsub = EmailUtil.add_subscriber_to_list(app.id,
                                                        funnel.email_list_id,
                                                        subscriber.id)
            if emailsub
              logger.info("Subscriber added to list")
            else
              logger.debug("Error adding subscriber to list!")
              return
            end
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

          logger.info ("Checking if job already exists")
          if EmailUtil.does_job_exist(app.id,
                                      funnel.id,
                                      node.id,
                                      subscriber.id)
            logger.info("Jobs Already Exists")
          else
            job = EmailUtil.create_new_email_job(app.id,
                                                 funnel.id,
                                                 subscriber.id,
                                                 node.id,
                                                 node.email_template_id,
                                                 funnel.email_list_id
            )
            if job
              logger.info("New Email Job Created!")
            else
              logger.debug("Error creating email job")
              return
            end
          end
        end
      end
    end
    logger.info("---Job Completed Properly---")
  end
end
