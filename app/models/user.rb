class User < RestModel

  has_many :apps

  include ActiveResource::Batches::ClassMethods
end
