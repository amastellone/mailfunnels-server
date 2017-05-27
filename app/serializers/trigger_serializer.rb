class TriggerSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :num_triggered, :num_emails_sent, :hook_id, :app_id
end
