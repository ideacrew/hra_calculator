Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :hra_results do
    collection do
      post :hra_payload
    end
  end
end
