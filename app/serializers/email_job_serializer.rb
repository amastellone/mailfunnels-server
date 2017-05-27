class EmailJobSerializer < ActiveModel::Serializer
  attributes :id, :subscriber_id, :funnel_id, :app_id, :executed
end
