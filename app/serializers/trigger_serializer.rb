class TriggerSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :emailSubject, :emailContent, :num_times_triggered, :num_emails_sent, :delayTime
end
