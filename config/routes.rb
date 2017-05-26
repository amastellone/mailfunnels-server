MailFunnelServer::Application.routes.draw do
  resources :email_list_subscribers
	mount ResourceApi => '/'

end
