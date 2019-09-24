Rails.application.routes.draw do
	mount_devise_token_auth_for 'Account', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :admin do
    collection do 
      post :premium_determination
    end 
  end

  resources :hra_results, :defaults => { :format => 'json' } do
    collection do
      post :hra_payload
    end
  end

  root to: 'admin#index'
end
