class BatchEmailJobSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_one :app
  has_one :email_list
  has_one :email_template
end
