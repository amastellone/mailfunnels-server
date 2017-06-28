class User < ApplicationRecord

  validates :email, presence: { strict: true }

  has_many :apps

end
