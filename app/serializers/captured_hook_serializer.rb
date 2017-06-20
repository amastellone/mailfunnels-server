class CapturedHookSerializer < ActiveModel::Serializer
  attributes :id, :revenue, :app_id
  has_one :hook
  has_one :subscribers
  has_one :app
end
