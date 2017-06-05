class Trigger < RestModel
  validates :name, presence: true

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :hook, :class_name => 'Hook', :foreign_key => 'hook_id'

  has_many :funnels

end
