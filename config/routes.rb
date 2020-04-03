Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root '/', as: :authenticated_root
  end
  devise_scope :user do
    root 'devise/sessions#new'
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
