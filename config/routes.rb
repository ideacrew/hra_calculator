Rails.application.routes.draw do
	mount_devise_token_auth_for 'Account', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :hra_results, :defaults => { :format => 'json' } do
    collection do
      post :hra_payload
    end
  end
end
