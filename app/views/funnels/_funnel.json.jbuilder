json.extract! funnel, :id, :name, :description, :numTriggers, :numRevenue, :created_at, :updated_at
json.url funnel_url(funnel, format: :json)