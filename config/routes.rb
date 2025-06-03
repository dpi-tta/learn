Rails.application.routes.draw do
  root "lessons#index"
  resources :lessons
  draw(:health)
  draw(:pwa)
end
