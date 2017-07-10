class ProcessCheckoutsJob < ApplicationJob
  queue_as :default

  def perform(app_id, shop)

    shop.with_shopify_session do

      app = App.find(app_id)
      subs_remaining = MailFunnelsUser.get_remaining_subs(app.user.clientid)

      # If no more subscribers left in plan, return error response
      if subs_remaining < 1
        return
      end

      trigger = Trigger.where(app_id: app_id, hook_id: 3).sort {|a, b| b.last_abondoned_id <=> a.last_abondoned_id}.first
      if trigger.nil? == true
        return
      end

      if trigger.last_abondoned_id == -1
        logger.info("NO Previous Abandoned checkout exist")
        abandonedCarts = ShopifyAPI::Checkout.where(created_at_min: 2.weeks.ago, limit: 250)
      else
        logger.info("Previous Abandoned checkout exist")
        abandonedCarts = ShopifyAPI::Checkout.where(since_id: trigger.last_abondoned_id, limit: 250)
      end
      if abandonedCarts.first.nil? == false

        logger.info("queing job")
        triggers = Trigger.where(app_id: app_id, hook_id: 3)
        triggers.each do |trigger|
          logger.info("UPDATING LAST ABANDONED TRIGGER")
          trigger.put('', :last_abondoned_id => abandonedCarts.last.id)
          logger.info("TRIGGER LAST ABANDONED SAVED")
        end


      else
        logger.info("No New abandoned checkout Found")
      end

      abandonedCarts.each do |abandoned_cart|
        if abandoned_cart.email.nil? == false
          logger.info("Looking for subscriber...")
          subscriber = Subscriber.where(app_id: app_id, email: abandoned_cart.email).first

          if subscriber
            logger.info("Subscriber found!")
          else
            logger.info("Subscriber does not exist, creating now")
            if abandoned_cart.shipping_address.first_name.nil? == false || abandoned_cart.shipping_address.last_name.nil? == false
              logger.info("shipping address information present")
              first_name = abandoned_cart.shipping_address.first_name
              last_name = abandoned_cart.shipping_address.last_name
            else
              logger.info("NO shipping address information present!")
              first_name = null
              last_name = null
            end
            subscriber = Subscriber.create(app_id: app_id,
                                           email: email,
                                           first_name: first_name,
                                           last_name: last_name,
                                           revenue: 0,
                                           initial_ref_type: 3,
            )
          end
          trigger = nil
          if subscriber
            abandoned_cart.line_items.each do |product|
              logger.info("checking triggers")
              trigger = Trigger.where(app_id: app_id, hook_id: 3, product_id: product.product_id).first
              if trigger
                break
              end
            end

            if trigger.nil? == true
              trigger = Trigger.where(app_id: app_id, hook_id: 3).first
            end

            if trigger.nil? == false
              logger.info("trigger found")
              logger.info("Looking for funnel")
              funnel = Funnel.where(app_id: app_id, trigger_id: trigger.id, active: 1).first
              if funnel
                logger.info("Funnel found!")
              else
                logger.debug("Funnel not found!")
                next
              end

              logger.info("Looking for start link")
              link = Link.where(funnel_id: funnel.id, start_link: 1).first

              if link
                logger.info("Start link found!")
              else
                logger.debug("Start link not found!")
                next
              end

              logger.info("looking for Node")
              node = Node.where(id: link.to_node_id).first

              if node
                logger.info("Node found!")
              else
                logger.debug("Node not found!")
                next
              end

              emailsub = EmailListSubscriber.where(app_id: app_id,
                                                   email_list_id: funnel.email_list_id,
                                                   subscriber_id: subscriber.id).first
              if emailsub
                logger.info("Email list subscription found!")
              else
                logger.info("No Email list subscription found!")
                emailsub = EmailListSubscriber.create(app_id: app_id,
                                                      email_list_id: funnel.email_list_id,
                                                      subscriber_id: subscriber.id)
                if emailsub
                  logger.info("Subscriber added to list")
                else
                  logger.debug("Error adding subscriber to list!")
                  next
                end
              end


              logger.info ("Checking if job already exists")
              job = EmailJob.where(app_id: app_id,
                                   funnel_id: funnel.id,
                                   node_id: node.id,
                                   subscriber_id: subscriber.id).first

              if job.nil? == false
                logger.info("Jobs Already Exists")
              else
                job = EmailJob.create(app_id: app_id,
                                      funnel_id: funnel.id,
                                      subscriber_id: subscriber.id,
                                      executed: false,
                                      node_id: node.id,
                                      email_template_id: node.email_template_id,
                                      email_list_id: funnel.email_list_id,
                                      sent: 0)
              end
            else
              next
            end

          end
        else
          logger.info("No email present")
        end
      end
    end
  end
end
