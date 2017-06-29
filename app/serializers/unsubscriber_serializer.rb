class UnsubscriberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :initial_ref_type
  has_one :app
end
