class BroadcastListSerializer < ActiveModel::Serializer
  attributes :id
  has_one :app
  has_one :batch_email_job
  has_one :email_list
end
