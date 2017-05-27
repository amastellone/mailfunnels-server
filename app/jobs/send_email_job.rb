class SendEmailJob < ApplicationJob
  @queue = :default

  def perform(job_id)

		puts "----EMAIL SENDING----"
		job = EmailJob.where(id: job_id).first
		funnel = Funnel.find(job.funnel_id)
		trigger = Trigger.find(funnel.trigger_id)
		node = Node.find(job.node_id)
		template = EmailTemplate.find(node.email_template_id)
		if job.sent == 1
			puts "email already sent"
		else
			client = Postmark::ApiClient.new('d8fcd810-8122-48d9-aada-e93064291543', http_open_timeout: 60)

			# response = client.deliver( # TODO: Enable + Test Postmark API
			# 		:subject     => template.email_subject,
			# 		:to          => 'matt@greekrow.online',
			# 		:from        => 'matt@greekrow.online',
			# 		:html_body   => template.email_content,
			# 		:track_opens => 'true')


			funnel.num_emails_sent = funnel.num_emails_sent+1
			funnel.save!

			trigger.num_emails_sent = trigger.num_emails_sent+1
			trigger.save!

			node.num_emails_sent = node.num_emails_sent+1
			node.save!

			job.executed = true
			job.postmark_id = 123 #response[:message_id]
			job.sent = 1
			job.save!
			puts "----EMAIL SENT----"
		end

		puts "----checking for next node in funnel----"
		link = Link.where(from_node: node.id).first
		if link.nil? == false
			nextNode = Node.where(id: link.to_node_id).first
			job = EmailJob.create(app_id: job.app_id, funnel_id: funnel.id, subscriber_id: job.subscriber_id, executed:  false,
												 node_id: link.to_node_id, email_template_id: nextNode.email_template_id, sent: 0)
			SendEmailJob.set(wait: nextNode.delay_time.minutes).perform_later(job.id)
				puts "next job queued"
		end
		puts "====JOB COMPLETED===="
    # # client = Postmark::ApiClient.new(ENV["POSTMARK"])
    # client = Postmark::ApiClient.new('e0ab21a2-3d3b-432b-8a77-132f25b58aa3', http_open_timeout: 60)
    #
    # job = Job.where(id: job_id).first
    # campaign = Campaign.where(id: job.campaign_id).first
    # email_list_id = campaign.email_list_id
    #
    # logger.info "App_ID: " + app_id.to_s
    # logger.info "Email_List_ID: " + email_list_id.to_s
    # logger.info "Campaign_ID: " + campaign.id.to_s
    # logger.info "Email_Subject: " + email_subject
    # logger.info "Email_Content: " + email_content
    # logger.info "Job_ID: " + job_id.to_s
    #
    # list = EmailList.where(id: email_list_id).first
    #
    # emails = Email.where(email_list_id: list.id)
    #
    # emails.each do |email|
    #
    #   template_system = false
    #   if template_system
		 #    # TODO: Create Documentation for adding dynamic datat to email.content (Jobs email content)
	   #    content = ''
	   #    content = email_content.gsub! '{$mf_recipient_name$}', email.name
	   #    content = content.gsub! '{$mf_recipient_email$}', email.email_address
    #   end
    #
    #   content = "This is an email sent to: " + email.email_address + " / Name: " + email.name + " / With Content: " + email_content;
    #
    #   # POSTMARK API
    #
    #   # Postmark API
    #   client.deliver( # TODO: Enable + Test Postmark API
    #   	 :subject     => email_subject,
    #   	 :to          => 'vas.kaloidis@gmail.com',
    #   	 :from        => 'admin@mailfunnels.com',
    #   	 :html_body   => email_content,
    #   	 :track_opens => 'true')
    #
    #   # :to          => email.email_address,
    #
    #   job = Job.find(job_id)
    #   job.executed = true
    #   job.execute_date = now
    #   job.save
    #
    #   # AUDIT
    #
    #   # Audit each email
    #   JobAudit.create(job_id: job_id, app_id: app_id,
    #                   subject: email_subject, content: email_content,
    #                   email_list_id: email_list_id, time_sent: Time.now,
    #                   recipient: email.email_address)
    #
    # end

  end

end