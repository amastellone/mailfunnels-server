class EmailList < RestModel

	has_many :subscribers
	belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'

end
