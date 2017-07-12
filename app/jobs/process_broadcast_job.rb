class ProcessBroadcastJob < ApplicationJob
  queue_as :default

  def perform(batch_job_id)

    batchEmailJob = BatchEmailJob.find(batch_job_id)

    broadcastLists = BroadcastList.where(batch_email_job_id: batch_job_id)


    broadcastLists.each do |broadcastList|

      subscribers = EmailListSubscriber.where(email_list_id: broadcastList.email_list_id)
      subscribers.each do |listSubscriber|
        emailJob = EmailJob.create(subscriber_id: listSubscriber.subscriber.id,
                                   email_template_id: batchEmailJob.email_template_id,
                                   email_list_id: broadcastList.email_list_id,
                                   app_id: batchEmailJob.app_id,
                                   batch_email_job_id: batchEmailJob.id,
                                   sent: 0,
                                   executed: false,
                                   clicked: 0)
        SendBatchEmailJob.perform_later(emailJob)
        sleep 1
      end

    end


  end
end
