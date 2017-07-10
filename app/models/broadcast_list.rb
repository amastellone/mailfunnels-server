class BroadcastList < RestModel
  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :batch_email_job, :class_name => 'BatchEmailJob', :foreign_key => 'batch_email_job_id'
  belongs_to :email_list, :class_name => 'EmailList', :foreign_key => 'email_list_id'
end
