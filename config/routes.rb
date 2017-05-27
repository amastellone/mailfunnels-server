MailFunnelServer::Application.routes.draw do
  resources :email_jobs
  resources :email_list_subscribers
	mount ResourceApi => '/'

end
