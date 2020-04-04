Rails.application.routes.draw do
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions' }
  devise_for :users, path: 'users', controllers: { sessions: 'users/sessions' }

  root to: "home#index"

  resources :appointments
end
