class Funnel < RestModel
  validates :name, presence: true
  validates :description, presence: true

  belongs_to :app
  has_many :nodes
  has_many :links
  has_many :email_jobs

end
