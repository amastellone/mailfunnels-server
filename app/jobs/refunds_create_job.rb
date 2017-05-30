
class RefundsCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    logger.info("Doing Refund Job")
    shop = Shop.find_by(shopify_domain: shop_domain)
    
    shop.with_shopify_session do
      app = MailfunnelsUtil.get_app
      logger.info("Finding order #{webhook[:order_id]}")
      order = ShopifyAPI::Order.find(:all, :params => {:limit => 1, :id =>webhook[:order_id] }).first
      if order.nil? == false
        logger.info("Order found!")

          logger.info("Checking if subscriber #{order.email} exists")
          subscriber = Subscriber.where(app_id: app.id, email: order.email).first
          if subscriber.nil? == true
            logger.info("Subscriber does not exist, creating now!")
            subscriber = Subscriber.create(app_id: app.id,
                                           email: order.email,
                                           first_name: order.billing_address.first_name,
                                           last_name: order.billing_address.last_name,
                                           revenue: 0)
          else
            logger.info("Subscriber exists!")
            logger.info("Incrementing Subscriber revenue...")
            subscriber.put('',:revenue => subscriber.revenue.to_f-order.subtotal_price.to_f)
            logger.info("Subscriber updated!")
          end

          logger.info("Looking for corresponding hook...")
          hook = Hook.where(identifier: 'refund_create').first
          if hook.nil? == false
            logger.info("Hook found!")
            logger.info("Looking for trigger")
            trigger = Trigger.where(app_id: app.id, hook_id: hook.id).first
            if trigger.nil? == false
              logger.info("Trigger found!")
              trigger.put('', :num_triggered => trigger.num_triggered+1)
              logger.info("Looking for funnel")
              funnel = Funnel.where(app_id: app.id, trigger_id: trigger.id).first
              if funnel.nil? == false
                logger.info("Funnel found!")
                logger.info("Incrementing Funnel revenue...")
                funnel.put('', :num_revenue => funnel.num_revenue.to_f-order.subtotal_price.to_f)
                logger.info("Funnel Updated!")
                logger.info("Checking if subscriber is in email list")
                emailsub = EmailListSubscriber.where(app_id: app.id,
                                                     email_list_id: funnel.email_list_id,
                                                     subscriber_id: subscriber.id).first
                if emailsub.nil? == true
                  logger.info("Subscriber not in list, adding now!")
                  EmailListSubscriber.post('', {:app_id => app.id,
                                                :subscriber_id => subscriber.id,
                                                :email_list_id => funnel.email_list_id})
                else
                  logger.info("Subscriber is already in list!")
                end
                logger.info("looking for link")
                link = Link.where(funnel_id: funnel.id, start_link: 1).first
                if link.nil? == false
                  logger.info("Link found!")
                  logger.info("looking for Node")
                  node = Node.where(id: link.to_node_id).first
                  if node.nil? == false
                    logger.info("Node Found")

                    logger.info "Checking if job already exists"
                    job = EmailJob.where(app_id: app.id,
                                         funnel_id: funnel.id,
                                         node_id: node.id,
                                         subscriber_id: subscriber.id).first
                    if job.nil? == true
                      logger.info("Job does not exist creating now")
                      logger.info("rendering email template for job")
                      EmailJob.post('', {:app_id => app.id,
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

                    logger.info("Job Completed!")
                  end
                end
              end
            end
          end
      end
    end
  end
end
