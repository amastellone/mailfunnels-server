class App < ApplicationRecord
	validates :name, presence: { strict: true }

	has_many :email_templates
	has_many :email_lists
	has_many :subscribers
	has_many :funnels
	has_many :nodes
	has_many :triggers
	has_many :email_jobs
	has_many :captured_hooks


end
