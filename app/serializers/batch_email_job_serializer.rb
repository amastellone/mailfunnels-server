class BatchEmailJobSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :email_list_id, :email_template_id, :app_id
  has_one :app
  has_one :email_list
  has_one :email_template
end
