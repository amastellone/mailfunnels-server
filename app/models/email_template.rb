class EmailTemplate < RestModel

  belongs_to :app,  :class_name => 'App', :foreign_key => 'app_id'

  has_many :nodes
  has_many :email_jobs

end
