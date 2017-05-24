class EmailTemplate < RestModel

  belongs_to :app,  :class_name => 'App', :foreign_key => 'app_id'

end
