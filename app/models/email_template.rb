class EmailTemplate < ApplicationRecord

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'

  has_many :email_jobs
  has_many :nodes

end
