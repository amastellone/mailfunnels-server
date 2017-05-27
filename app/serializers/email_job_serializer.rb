class EmailJobSerializer < ActiveModel::Serializer
  attributes :id, :executed, :sent, :opened, :clicked, :postmark_id, :subscriber_id, :funnel_id, :app_id, :node_id, :email_template_id
end
