class BroadcastListSerializer < ActiveModel::Serializer
  attributes :id, :batch_email_job_id, :app_id, :email_list_id
  has_one :app
  has_one :batch_email_job
  has_one :email_list
end
