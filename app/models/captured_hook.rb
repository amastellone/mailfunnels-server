class CapturedHook < RestModel

  belongs_to :app,  :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :hook ,:class_name => 'Hook', :foreign_key => 'hook_id'
  belongs_to :subscriber ,:class_name => 'Subscriber', :foreign_key => 'subscriber_id'

end
