Rails.application.routes.draw do
  root 'devices#index'

  resources :devices do
    resources :cameras, shallow: true
  end
end
