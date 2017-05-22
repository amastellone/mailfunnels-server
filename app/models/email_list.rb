class EmailList < RestModel

	has_many :subscribers
	belongs_to :app

end
