
Infusionsoft.configure do |config|
  config.api_url = 'gv373.infusionsoft.com' # example infused.infusionsoft.com DO NOT INCLUDE https://
  config.api_key = '94c11c8a7a198e08f6ba3b58bf5d592a'
  config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_api.log") # optional logger file
end