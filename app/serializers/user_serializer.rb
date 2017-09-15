class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :password, :clientid, :client_tags, :email, :street_address, :city, :state, :zip, :has_mailfunnel_watermark,
end
