class EmailList < RestModel

	belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'


  has_many :email_list_subscribers
  has_many :email_jobs
  has_many :unsubscribers
  has_many :broadcast_lists

end
