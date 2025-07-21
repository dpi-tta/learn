namespace :webhooks do
  resources :github, only: :create
end
