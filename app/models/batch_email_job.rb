class BatchEmailJob < RestModel

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :email_template, :class_name => 'EmailTemplate', :foreign_key => 'email_template_id'

  has_many :email_jobs
  has_many :broadcast_lists

end
