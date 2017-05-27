class EmailJob < RestModel
  belongs_to :app
  belongs_to :funnel
  belongs_to :subscriber

end
