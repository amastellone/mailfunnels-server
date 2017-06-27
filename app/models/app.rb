class App < RestModel

	belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

	has_many :email_templates
	has_many :email_lists
	has_many :subscribers
	has_many :funnels
	has_many :nodes
	has_many :triggers
	has_many :email_jobs
	has_many :captured_hooks
	has_many :batch_email_jobs
	has_many :unsubscribers

end
