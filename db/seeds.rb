# MAIL FUNNEL - CLIENT SEEDS


# TODO: Finish the Config Model
MailFunnelConfig.create(name: "app_installed", value: "true")
MailFunnelConfig.create(name: "app_key", value: ENV['APP_KEY'])
MailFunnelConfig.create(name: "app_secret", value: ENV['APP_SECRET'])
MailFunnelConfig.create(name: "app_url", value: ENV['APP_URL'])
MailFunnelConfig.create(name: "app_scope", value: ENV['APP_SCOPE'])
MailFunnelConfig.create(name: "app_name", value: ENV['mail-funnel-client'])

MailFunnelConfig.create(name: "server_url", value: ENV['SERVER_URL'])

MailFunnelConfig.create(name: "dev_shop_name", value: "bluehelmet-dev")

rest_server_interaction = true
if rest_server_interaction

	# CLIENT INSTALL-SCRIPT:
	domain = 'bluehelmet-dev.myshopify.com'
	app_create = App.where(name: domain) # bluehelmet-dev.myshopifyapp.com

	if app_create.empty?
		puts "Creating App + " + domain
		digest = OpenSSL::Digest.new('sha256')
		token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], domain)).strip
		app_create = App.create(name: domain, auth_token: token)
		app        = app_create
		puts "App did not exist, created with id: " + app.id.to_s
	else
		puts "Blue Helmet Dev App already exists " +  app_create.id
		app = app_create.first
		puts "App exists already, id: " + app.id.to_s
	end

	# EMAIL + EMAIL_LISTS

	# Default List
	default_list_check = EmailList.where(name: "Default", app_id: app.id)

	if default_list_check.empty?
		default_list_check = EmailList.create(name:        "Default",
		                                      description: "The default Mail-Funnel email list",
		                                      app_id:      app.id)
		defaultlist        = default_list_check
		puts "Default list does not exist, create it, id: " + defaultlist.id.to_s
	else
		defaultlist = default_list_check.first
		puts "Default list exists already, id: " + defaultlist.id.to_s
	end
	$x = 0 # Generate Emails for Default List
	until $x > Random.rand(3...15) do
		email = Email.create(email_address: Faker::Internet.email,
		                     name:          Faker::Name.name,
		                     app_id:        app,
		                     email_list_id: defaultlist.id)
		puts "Emails Created for List " + defaultlist.name + " - " + email.email_address
		puts defaultlist.name.to_s + ": Email Created " + email.email_address.to_s
		$x += 1
	end

	# Other Email Lists and Emails
	lists = Array.new
	$x    = 0
	until $x > Random.rand(2...3) do
		list = EmailList.create(name:        Faker::App.name,
		                        description: Faker::Lorem.sentence,
		                        app_id:      app.id)
		lists << list.id
		$y = 0
		until $y > Random.rand(1...10) do
			email = Email.create(email_address: Faker::Internet.email,
			                     name:          Faker::Name.name,
			                     app_id:        app.id,
			                     email_list_id: list.id)
			puts list.name.to_s + ": Email Created " + email.email_address.to_s
			$y += 1
		end
		$x += 1
	end


	# Add a Testing Funnel
	Funnel.create(name: 'Testing Funnel 1',
								description: 'This is a testing funnel for development purposes.',
								app_id: app.id)


	# Add A Trigger
	Trigger.create(name: 'Add Product To Cart',
								 description: 'When a product is added to cart, this trigger is hit.',
								 esubject: 'Welcome!',
								 econtent: 'Thanks for adding a product to the cart. Look at the deals here!',
								 app_id: app.id,
								 email_list_id: 1,
								 hook_id: 1,
								 ntriggered: 0,
								 nesent: 0,
								 delayt: 3)

end