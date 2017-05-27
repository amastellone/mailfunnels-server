class Funnel < ApplicationRecord
  validates :name, presence: true

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'
  belongs_to :trigger, :class_name => 'Trigger', :foreign_key => 'trigger_id'
  belongs_to :email_list, :class_name => 'EmailList', :foreign_key => 'email_list_id'


  has_many :nodes
  has_many :links
  has_many :email_jobs

end
