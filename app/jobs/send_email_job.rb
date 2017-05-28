require "erb"

class SendEmailJob < ApplicationJob
  @queue = :default

  def perform(job_id)

		puts"Gathering Email Job Info"
		job = EmailJob.where(id: job_id).first
		funnel = Funnel.find(job.funnel_id)
		trigger = Trigger.find(funnel.trigger_id)
		node = Node.find(job.node_id)
		template = EmailTemplate.find(node.email_template_id)
		if job.sent == 1
			puts"Email Already Sent to Subscriber"
		else
			puts "Rendering email template"
			@template = template
			html = File.open("app/views/email/template.html.erb").read
			@renderedhtml = "1"
			ERB.new(html, 0, "", "@renderedhtml").result(binding)
			puts "Template rendered!"
			puts"Creating Postmark Client"
			client = Postmark::ApiClient.new('d8fcd810-8122-48d9-aada-e93064291543', http_open_timeout: 60)
			puts"Sending Email..."
			response = client.deliver(
					:subject     => template.email_subject,
					:to          => 'matt@greekrow.online',
					:from        => 'matt@greekrow.online',
					:html_body   => @renderedhtml,
					:track_opens => 'true',
					:track_links => 'HtmlAndText')
			puts"Email Sent!"

			funnel.num_emails_sent = funnel.num_emails_sent+1
			funnel.save!
			puts"Incrementing Funnel num_emails_sent"
			trigger.num_emails_sent = trigger.num_emails_sent+1
			trigger.save!
			puts"Incrementing Trigger num_emails_sent"
			node.num_emails_sent = node.num_emails_sent+1
			node.save!
			puts"Incrementing Node num_emails_sent"
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