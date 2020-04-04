Rails.application.routes.draw do
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions', registrations: 'patients/registrations' }
  devise_for :users, path: 'users', controllers: { sessions: 'users/sessions' }

  devise_scope :patient do
    root 'patients/sessions#new'
  end

  devise_scope :user do
    get 'ubs/active_hours', as: :ubs_active_hours
    patch 'ubs/change_active_hours', as: :ubs_change_active_hours
    match 'ubs/slot_duration', via: [:get, :patch], as: :ubs_slot_duration
  end
end
