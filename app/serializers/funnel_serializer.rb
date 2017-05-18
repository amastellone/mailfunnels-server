class FunnelSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :numTriggers, :numRevenue, :app_id
end
