class Subscriber < ApplicationRecord

  belongs_to :app,  :class_name => 'App', :foreign_key => 'app_id'

  has_many :email_list_subscribers, :dependent => :destroy
  has_many :email_jobs


end
