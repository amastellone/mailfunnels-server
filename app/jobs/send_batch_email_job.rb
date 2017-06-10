require "erb"

class SendBatchEmailJob < ApplicationJob
  queue_as :default

  def perform(job)
    puts"Gathering Email Job Info"
    job = EmailJob.where(id: job.id).first
    template = EmailTemplate.find(job.email_template_id)
    subscriber = Subscriber.find(job.subscriber_id)
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

      job.executed = true
      job.postmark_id = response[:message_id]
      job.sent = 1
      job.save!
      puts"Email Job updated to executed and message id set"
    end
    puts"Email Job Completed!"

  end
end
