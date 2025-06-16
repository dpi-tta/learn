Rails.application.routes.draw do
  root "courses#index"
  resources :courses
  resources :lessons
  draw(:health)
  draw(:pwa)
end
