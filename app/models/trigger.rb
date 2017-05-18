class Trigger < RestModel
  validates :name, presence: true

  belongs_to :app

end
