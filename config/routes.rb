Rails.application.routes.draw do
  root "courses#index"
  resources :courses
  resources :lessons
  resource :session
  resources :passwords, param: :token
  draw(:health)
  draw(:pwa)
  draw(:webhooks)
end
