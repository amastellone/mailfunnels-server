class CapturedHook < ApplicationRecord

  belongs_to :hook,  :class_name => 'Hook', :foreign_key => 'hook_id'
  belongs_to :app,  :class_name => 'App', :foreign_key => 'app_id'
end
