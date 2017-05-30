class SubscriberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :revenue, :app_id
  has_one :app
end
