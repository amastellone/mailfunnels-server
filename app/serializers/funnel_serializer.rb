class FunnelSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :num_emails_sent, :num_revenue, :app_id, :trigger_id, :email_list_id
end
