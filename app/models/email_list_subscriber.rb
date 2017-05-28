class EmailListSubscriber < RestModel
  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :subscribers, :class_name => 'Subscriber', :foreign_key => 'subscriber_id'
  belongs_to :email_list, :class_name => 'EmailList', :foreign_key => 'email_list_id'
end
