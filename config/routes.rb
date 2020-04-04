Rails.application.routes.draw do
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions' }
  devise_for :users, path: 'users'

  devise_scope :patient do
    root 'patients/sessions#new'
  end
end
