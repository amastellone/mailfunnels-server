class UnsubscriberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email
  has_one :app
end
