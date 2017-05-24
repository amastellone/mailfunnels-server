class Trigger < RestModel
  validates :name, presence: true

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'

end
