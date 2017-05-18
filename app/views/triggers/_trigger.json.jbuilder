json.extract! trigger, :id, :name, :description, :emailSubject, :emailContent, :num_times_triggered, :num_emails_sent, :delayTime, :created_at, :updated_at
json.url trigger_url(trigger, format: :json)