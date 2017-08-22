class User < RestModel.extend(ActiveResource::Batches::ClassMethods)

  has_many :apps

end
