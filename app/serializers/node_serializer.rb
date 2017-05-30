class NodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :top, :left, :num_emails, :num_emails_sent, :num_email_opened, :num_emails_clicked, :num_revenue, :delay_time, :delay_unit, :app_id, :funnel_id, :email_template_id
end
