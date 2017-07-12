class BatchEmailJobSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :email_template_id, :app_id
  has_one :app
  has_one :email_template
end
