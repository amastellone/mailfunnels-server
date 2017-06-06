class TriggerSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :num_triggered, :num_emails_sent, :product_id, :hook_id, :app_id
end
