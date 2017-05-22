class Subscriber < RestModel

  belongs_to :app,  :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :email_list,  :class_name => 'EmailList', :foreign_key => 'email_list_id'

  has_many :captured_hooks

end
