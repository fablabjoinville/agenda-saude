Rails.application.routes.draw do
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions', registrations: 'patients/registrations' }
  devise_for :users, path: 'users', controllers: { sessions: 'users/sessions' }

  devise_scope :patient do
    root to: 'patients/sessions#new'
  end

  devise_scope :user do
    get 'ubs/active_hours', as: :ubs_active_hours
    patch 'ubs/change_active_hours', as: :ubs_change_active_hours

    get 'ubs/slot_duration', as: :ubs_slot_duration
    patch 'ubs/change_slot_duration', as: :ubs_change_slot_duration
  end

  resources :appointments

  resources :ubs
end
