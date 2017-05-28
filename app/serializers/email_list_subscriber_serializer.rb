class EmailListSubscriberSerializer < ActiveModel::Serializer
  attributes :id
  has_one :app
  has_one :subscribers
  has_one :email_list
end
