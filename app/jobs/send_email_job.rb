require "erb"

class SendEmailJob < ApplicationJob
  @queue = :default

  def perform(job_id)

		puts"Gathering Email Job Info"
		job = EmailJob.where(id: job_id).first
		if job.nil? == false

		funnel = Funnel.find(job.funnel_id)
		if funnel.nil? == false
			trigger = Trigger.find(funnel.trigger_id)
		end
		template = EmailTemplate.find(job.email_template_id)
		subscriber = Subscriber.find(job.subscriber_id)
		node = Node.find(job.node_id)
		if job.sent == 1
			puts"Email Already Sent to Subscriber"
		else
			puts "Rendering email template"
			@template = template
			@email_job = job
			@subscriber = subscriber
			html = File.open("app/views/email/template.html.erb").read
			@renderedhtml = "1"
			ERB.new(html, 0, "", "@renderedhtml").result(binding)
			puts "Template rendered!"
			puts"Creating Postmark Client"
			client = Postmark::ApiClient.new('b650bfe2-d2c6-4714-aa2d-e148e1313e37', http_open_timeout: 60)
			puts"Sending Email..."
			 response = client.deliver(
			 		:subject     => template.email_subject,
			 		:to          => subscriber.email,
			 		:from        => 'matt@greekrow.online',
			 		:html_body   => @renderedhtml,
			 		:track_opens => 'true',
			 		:track_links => 'HtmlAndText')

			puts"Email Sent!"

			if trigger.nil? == false
			trigger.num_emails_sent = trigger.num_emails_sent+1
			trigger.save!
			puts"Incrementing Trigger num_emails_sent"
			end

			job.executed = true
			job.postmark_id = response[:message_id]
			job.sent = 1
			job.save!
			puts"Email Job updated to executed and message id set"
		end

		puts"Checking for next node in funnel"
		link = Link.where(from_node: node.id).first
		if link.nil? == false
			puts"Next Node in funnel found!"
			nextNode = Node.where(id: link.to_node_id).first
			job = EmailJob.create(app_id: job.app_id,
														funnel_id: funnel.id,
														subscriber_id: job.subscriber_id,
														executed:  false,
														node_id: link.to_node_id,
														email_template_id: nextNode.email_template_id,
														sent: 0)
			# set to hours
			SendEmailJob.set(wait: nextNode.delay_time.seconds).perform_later(job.id)
			puts"Next Email Job Queued"
		else
			puts"No Node found!"
		end
		puts"Email Job Completed!"
		end
  end

end