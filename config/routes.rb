MailFunnelServer::Application.routes.draw do
	mount ResourceApi => '/'

  # Unsubscribe Page Route
  get '/unsubscribe/:subscriber_id', to: 'subscribers#unsubscribe_page'

end
