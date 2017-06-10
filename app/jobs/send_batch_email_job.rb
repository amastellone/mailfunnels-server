require "erb"

class SendBatchEmailJob < ApplicationJob
  queue_as :default

  def perform(job)
    job = EmailJob.where(id: job.id).first
    template = EmailTemplate.find(job.email_template_id)
    subscriber = Subscriber.find(job.subscriber_id)
    if job.sent == 1
      puts"Email Already Sent to Subscriber"
    else
      @template = template
      @email_job = job
      @subscriber = subscriber
      html = File.open("app/views/email/template.html.erb").read
      @renderedhtml = "1"
      ERB.new(html, 0, "", "@renderedhtml").result(binding)
      puts "Template rendered!"
      puts"Creating Postmark Client"
      client = Postmark::ApiClient.new(ENV['POSTMARK'], http_open_timeout: 60)
      response = client.deliver(
          :subject     => template.email_subject,
          :to          => subscriber.email,
          :from        => 'matt@greekrow.online',
          :html_body   => @renderedhtml,
          :track_opens => 'true',
          :track_links => 'HtmlAndText')

      job.executed = true
      job.postmark_id = response[:message_id]
      job.sent = 1
      job.save!
    end
  end
end
