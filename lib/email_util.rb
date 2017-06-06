class EmailUtil


  # returns subscriber if exists, returns false otherwise
  def self.get_subscriber(email, app_id)
    subscriber = Subscriber.where(app_id: app_id, email: email).first
    if subscriber.nil? == false
      return subscriber
    else
      return false
    end
  end

  def self.add_new_subscriber(email, app_id, first_name, last_name)
    subscriber = Subscriber.create(app_id: app_id,
                                   email: email,
                                   first_name: first_name,
                                   last_name: last_name,
                                   revenue: 0)
    if subscriber.nil? == false
      return subscriber
    else
      return false
    end
  end

  def self.increase_subscriber_revenue(subscriber, amount)
    subscriber = subscriber.put('',:revenue => subscriber.revenue.to_f+amount)
    if subscriber.nil? == false
      return subscriber
    else
      return false
    end
  end

  def self.decrease_subscriber_revenue(subscriber, amount)
    subscriber = subscriber.put('',:revenue => subscriber.revenue.to_f-amount)
    if subscriber.nil? == false
      return subscriber
    else
      return false
    end
  end

  def self.set_subscriber_revenue(subscriber, amount)
    subscriber = subscriber.put('',:revenue => amount)
    if subscriber.nil? == false
      return subscriber
    else
      return false
    end
  end

  def self.get_email_list_subscription(app_id, email_list_id, subscriber_id)
    emailsub = EmailListSubscriber.where(app_id: app_id,
                                         email_list_id: email_list_id,
                                         subscriber_id: subscriber_id).first
    if emailsub.nil? == false
      return emailsub
    else
      return false
    end

  end

  def self.add_subscriber_to_list(app_id, email_list_id, subscriber_id)
    emailsub = EmailListSubscriber.post('', {:app_id => app_id,
                                  :subscriber_id => subscriber_id,
                                  :email_list_id => email_list_id})

    if emailsub.nil? == false
      return emailsub
    else
      return false
    end
  end

  def self.get_funnel(app_id, trigger_id)
    funnel = Funnel.where(app_id: app_id, trigger_id: trigger_id).first
    if funnel.nil? == false
      return funnel
    else
      return false
    end
  end

  def self.increase_funnel_revenue(funnel, amount)
    funnel = funnel.put('', :num_revenue => funnel.num_revenue+amount)
    if funnel.nil? == false
      return funnel
    else
      return false
    end
  end

  def self.get_trigger(app_id, hook_id)
    trigger = Trigger.where(app_id: app_id, hook_id: hook_id).first
    if trigger.nil? == false
      return trigger
    else
      return false
    end
  end

  def self.get_trigger_product(app_id, hook_id, product_id)
    trigger = Trigger.where(app_id: app_id, hook_id: hook_id, product_id: product_id).first
    if trigger.nil? == false
      return trigger
    else
      return false
    end
  end

  def self.increment_trigger_hit_count(trigger)
    trigger = trigger.put('', :num_triggered => trigger.num_triggered+1)
    if trigger.nil? == false
      return trigger
    else
      return false
    end
  end

  def self.get_node(node_id)
    node = Node.where(id: node_id).first
    if node.nil? == false
      return node
    else
      return false
    end
  end

  def self.get_start_link(funnel_id)
    link = Link.where(funnel_id: funnel_id, start_link: 1).first

    if link
      return link
    else
      return false
    end

  end

  def self.get_hook(identifier)
    hook = Hook.where(identifier: identifier).first
    if hook.nil? == false
      return hook
    else
      return false
    end
  end

  def self.does_job_exist(app_id, funnel_id, node_id, subscriber_id)
    job = EmailJob.where(app_id: app_id,
                         funnel_id: funnel_id,
                         node_id: node_id,
                         subscriber_id: subscriber_id).first
    if job.nil? == false
      return true
    else
      return false
    end
  end

  def self.create_new_email_job(app_id, funnel_id, subscriber_id, node_id, email_template_id)
    job = EmailJob.post('', {:app_id => app_id,
                       :funnel_id => funnel_id,
                       :subscriber_id => subscriber_id,
                       :executed => false,
                       :node_id => node_id,
                       :email_template_id => email_template_id,
                       :sent => 0})
    if job.nil? == false
      return job
    else
      return false
    end
  end




end