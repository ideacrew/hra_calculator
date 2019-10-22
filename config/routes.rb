Rails.application.routes.draw do

  devise_for :accounts, :controllers => { :sessions => "accounts/sessions"}

  devise_scope :account do
    root to: "accounts/sessions#new"
  end

  namespace :admin do
    root 'enterprise#show'
    resources :accounts, only: [:destroy] do
      member do
        get :reset_password
        patch :password_reset
      end
    end

    resources :enterprise, only: [:show] do
      post :account_create
      post :tenant_create
      post :benefit_year_create
      post :benefit_year_update
      get :purge_hra
    end

    resources :tenants, only: [:show, :update] do
      post  :upload_logo
      get   :features_show
      put   :features_update
      get   :translations_show
      get   :fetch_locales
      get   :edit_translation
      post  :update_translation
      get   :plan_index
      post  :upload_plan_data
      post  :zip_county_data
      get   :plans_destroy
    end
  end

	# mount_devise_token_auth_for 'Account', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :configurations, :defaults => { :format => 'json' } do
      collection do
        get :default_configuration
        get :counties
        get :header_footer_config
      end
    end

    resources :hra_results, :defaults => { :format => 'json' } do
      collection do
        post :hra_payload
      end
    end

    resources :translations, only: [:show] do
    end

    resources :client_sessions, only: [] do
      collection do
        get :issue_token
      end
    end
  end

  resources :hra_results, :defaults => { :format => 'json' } do
    collection do
      post :hra_payload
      get :header_footer_config
    end
  end

  resources :configurations, :defaults => { :format => 'json' } do
    collection do
      get :default_configuration
      get :counties
    end
  end

  # root to: 'admin#index'
end
