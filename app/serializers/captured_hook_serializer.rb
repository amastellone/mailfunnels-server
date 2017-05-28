class CapturedHookSerializer < ActiveModel::Serializer
  attributes :id
  has_one :hook
  has_one :subscribers
  has_one :app
end
