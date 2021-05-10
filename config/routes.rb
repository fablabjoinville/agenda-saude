Rails.application.routes.draw do
  namespace :community do
    resource :session, only: %i[create destroy]
    resource :patient, only: %i[new create edit update]

    resources :appointments, only: %i[index create destroy] do
      collection do
        get :home
        get :vaccinated # not a collection one but due to the way we have appointments right now
      end
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    namespace :operator do
      resources :ubs, only: %i[index show] do
        member do
          patch :activate
          patch :suspend
        end

        resources :appointments, only: %i[index show] do
          member do
            patch :check_in
            patch :check_out
            patch :suspend
            patch :activate
          end
        end
      end
    end

    namespace :admin do
      resources :appointments, only: %i[index show]
      resources :groups, only: %i[index new create show edit update]
      resources :neighborhoods, only: %i[index show]
      resources :pages
      resources :patients, only: %i[index show] do
        member do
          patch :unblock
        end
      end
      resources :ubs, only: %i[index show]
      resources :users, only: %i[index show]
      resources :vaccines, only: %i[index show]
    end
    resources :appointments, only: %i[index]
  end

  resources :pages, only: :show, path: '/p'

  get 'community', to: redirect('/community/appointments/home')
  get 'operator', to: redirect('/operator/ubs')
  get 'admin', to: redirect('/admin/patients')
  root 'home#index'
end
