Rails.application.routes.draw do
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions', registrations: 'patients/registrations' }
  devise_for :users, path: 'users'

  devise_scope :patient do
    root 'home#index'
  end

  post 'home/patient_base_login', as: :patient_base_login, to: 'home#patient_base_login'
end
