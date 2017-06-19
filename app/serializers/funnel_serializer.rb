class FunnelSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :num_emails_sent, :num_revenue, :active, :app_id, :trigger_id, :email_list_id
end
