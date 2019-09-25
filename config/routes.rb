Rails.application.routes.draw do
  
  namespace :admin do
    get  'tenants/show'
    put  'tenants/update'
    post 'tenants/upload_logo'
    get  'tenants/features_show'
    put  'tenants/features_update'
    get  'tenants/ui_pages_show'
    get  'tenants/ui_element_update'
    get  'tenants/plan_index'
    post 'tenants/upload_plan_data'
    post 'tenants/zip_county_data'
  end
  
  namespace :admin do
    get  'enterprise/show'
    post 'enterprise/account_create'
    post 'enterprise/tenant_create'
    post 'enterprise/tenant_update'
    post 'enterprise/benefit_year_create'
    post 'enterprise/benefit_year_update'
  end

	mount_devise_token_auth_for 'Account', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :configurations, :defaults => { :format => 'json' } do
      collection do
        get :default_configuration
        get :counties
      end
    end

    resources :hra_results, :defaults => { :format => 'json' } do
      collection do
        post :hra_payload
      end
    end
  end

  resources :hra_results, :defaults => { :format => 'json' } do
    collection do
      post :hra_payload
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
