Rails.application.routes.draw do
  # Main
  root :to => 'main_interface#index'

  # Funnel Page Render Routes
  get '/funnels', to: 'funnels#index'
  get '/edit_funnel/:funnel_id', to: 'funnels#edit_funnel'

  # Funnel Editor POST Routes
  post '/create_funnel' => 'funnels#ajax_create_funnel'
  post '/ajax_add_new_node' => 'funnels#ajax_add_node'
  post '/ajax_load_funnel_json' => 'funnels#ajax_load_funnel_json'
  post '/ajax_save_node' => 'funnels#ajax_save_node'
  post '/ajax_add_link' => 'funnels#ajax_add_link'
  post '/ajax_load_node_info' => 'funnels#ajax_load_node_info'

  # Trigger Routes
  get '/triggers', to: 'triggers#index'
  post '/create_trigger', to: 'triggers#ajax_create_trigger'

  # Subscribers Routes
  get '/all_subscribers', to: 'main_interface#all_subscribers'

  # Email Template Routes
  get '/email_templates', to: 'email#email_templates'
  get '/view_email_template/:template_id', to: 'email#view_email_template'
  get '/edit_email_template/:template_id', to: 'email#edit_email_template'
  get '/view_email', to: 'email#view_email'
  post '/ajax_create_email_template' => 'email#ajax_create_email_template'


  # Email Controller
  get '/lists', to: 'email#lists'
  get '/emails/:list_id', to: 'email#emails'
  get '/new_list', to: 'email#new_list'
  match '/create_list' => 'email#create_list', via: [:post]


  # Shopify Routes
  get 'modal' => "home#modal", :as => :modal
  get 'modal_buttons' => "home#modal_buttons", :as => :modal_buttons
  get 'regular_app_page' => "home#regular_app_page"
  get 'help' => "home#help"
  get 'pagination' => "home#pagination"
  get 'breadcrumbs' => "home#breadcrumbs"
  get 'buttons' => "home#buttons"
  get 'form_page' => "home#form_page"
  post 'form_page' => "home#form_page"
  get 'error' => 'home#error'

  mount ShopifyApp::Engine, at: '/'

  # namespace :app_proxy do
  #   root action: 'index'
    # simple routes without a specified controller will go to AppProxyController

    # resources :hooks_constants
    # resources :users
      # resources :campaigns

    # more complex routes will go to controllers in the AppProxy namespace
    # 	resources :reviews
    # GET /app_proxy/reviews will now be routed to
    # AppProxy::ReviewsController#index, for example
  # end
end
