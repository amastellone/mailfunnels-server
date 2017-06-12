class EmailList < ApplicationRecord
  validates :name, presence: true

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'

  has_many :email_list_subscribers
  has_many :email_jobs

end
