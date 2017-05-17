class FunnelSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :numTriggers, :numRevenue
end
