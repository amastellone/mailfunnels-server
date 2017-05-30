#SERVER - Seeds.rb

require 'sidekiq/api'
Sidekiq::Queue.new.clear

# Config
MailFunnelServerConfig.create(name: "app_name", value: ENV["APP_NAME"])
MailFunnelServerConfig.create(name: "app_key", value: ENV["APP_KEY"])
MailFunnelServerConfig.create(name: "app_secret", value: ENV["APP_SECRET"])
MailFunnelServerConfig.create(name: "app_scope", value: ENV["APP_SCOPE"])
#
# server_url = "http://localhost:3001/"
server_url = ENV['APP_URL']
MailFunnelServerConfig.create(name: "app_url", value: server_url)
MailFunnelServerConfig.create(name: "api_url", value: server_url + "api/")


# Order
order_create_hook    = Hook.create(name: 'Customer purchased product', identifier: 'order_create');

# Refund
refund_create_hook    = Hook.create(name: 'Customer refunded product', identifier: 'refund_create');

seed_data = false

if seed_data

	generate_client_data = false

# GENERATE OUR DEFAULT DATA
# TODO: Move this to client-install
	if generate_client_data

		app_create = App.new(name: ShopifyAPI::Shop.current.domain)
		if app_create.new_record?
			app_create.save!
			puts "App did not exist, created with id: " + app.id.to_s
		else
			puts "App exists already"
		end

		app         = app_create.id

		# app_create = BluehelmetUtil.get_app
		# app        = app_create.id
		defaultlist = EmailList.new(name:        "Default",
		                            description: "The default Mail-Funnel email list",
		                            app_id:      app);

		if defaultlist.new_record?
			puts "Default list does not exist, create it"
			defaultlist.save!
		else
			puts "Default list exists already"
		end

		$y = 0
		until $y > Random.rand(1...5) do
			email = Email.create(email_address: Faker::Internet.email,
			                     app_id:        app,
			                     email_list_id: defaultlist.id);
			puts defaultlist.name.to_s + ": Email Created " + email.email.to_s
			$y += 1
		end

		# GENERATE OUR OTHER Data
		$x = 0
		until $x > Random.rand(2...3) do
			list = EmailList.create(name:        "Email List some Name " + $x.to_s,
			                        description: "A Mail-Funnel email list",
			                        app_id:      app)

			$y = 0
			until $y > Random.rand(1...10) do
				email = Email.create(email_address: Faker::Internet.email,
				                     name:          Faker::Name.name,
				                     app_id:        app,
				                     email_list_id: list.id)
				puts list.name.to_s + ": Email Created " + email.email.to_s
				$y += 1
			end
			$x += 1
		end

	else
		# What to do if we didn't create client data - nothing
	end



end