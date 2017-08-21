class User < RestModel

  has_many :apps

  include Concerns::Batches

end
