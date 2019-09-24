Rails.application.routes.draw do
	mount_devise_token_auth_for 'Account', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'admin#index'

  resources :hra_results, :defaults => { :format => 'json' } do
    collection do
      get :hra_information
      get :hra_counties
      post :hra_payload
    end
  end
end
