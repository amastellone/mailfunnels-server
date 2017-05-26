class EmailList < RestModel

	belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'

	has_many :subscribers

end
