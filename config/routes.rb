MailFunnelServer::Application.routes.draw do
	mount ResourceApi => '/'

  # Unsubscribe Page Route
  get '/unsubscribe/:subscriber_id', to: 'subscribers#unsubscribe_page'

  # Postmark Webhook Routes
  post '/email_opened' => 'email_jobs#email_opened_hook'

end
