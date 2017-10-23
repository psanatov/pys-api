Rails.application.routes.draw do
  resources :entries do
    resources :items
  end
end
