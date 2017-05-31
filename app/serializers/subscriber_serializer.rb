class SubscriberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :revenue, :app_id, :created_at
  has_one :app
end
