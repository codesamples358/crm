Rails.application.routes.draw do
  resources :calls do
    member do
      get :download
    end
  end

  resources :services

  resources :corp_packs do
    resources :services, only: :index, controller: 'corp_packs/services'
  end

  resources :corp_pack_services

  resources :players do

    collection do
      get :by_phone
    end

  end
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/admin_lte', to: 'admin_lte#index'
  get '/admin_lte/v2', to: 'admin_lte#index2'



  get '/admin_lte/top-nav', to: 'admin_lte#top_nav'
  get '/admin_lte/boxed', to: 'admin_lte#boxed'
  get '/admin_lte/fixed', to: 'admin_lte#fixed'
  get '/admin_lte/collapsed-sidebar', to: 'admin_lte#collapsed_sidebar'


  get '/admin_lte/widgets', to: 'admin_lte#widgets'


  get '/admin_lte/charts/chart_js', to: 'admin_lte#chart_js'
  get '/admin_lte/charts/morris', to: 'admin_lte#morris'
  get '/admin_lte/charts/flot', to: 'admin_lte#flot'
  get '/admin_lte/charts/inline', to: 'admin_lte#inline'


  get '/admin_lte/tables/simple', to: 'admin_lte#simple'
  get '/admin_lte/tables/data', to: 'admin_lte#data'
  get '/admin_lte/tables/data2', to: 'admin_lte#data2'

  get '/admin_lte/forms/general', to: 'admin_lte#general_forms'
  get '/admin_lte/forms/advanced', to: 'admin_lte#advanced_forms'


  namespace :online_pbx do
    post '/', to: 'events#create'
  end

  root to: 'home#index'
end
