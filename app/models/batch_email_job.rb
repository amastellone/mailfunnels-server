class BatchEmailJob < RestModel

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :email_list, :class_name => 'EmailList', :foreign_key => 'email_list_id'
  belongs_to :email_template, :class_name => 'EmailTemplate', :foreign_key => 'email_template_id'

  has_many :email_jobs

end
