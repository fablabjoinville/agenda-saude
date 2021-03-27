Rails.application.routes.draw do
  devise_for :patients, controllers: { sessions: 'patients/sessions', registrations: 'patients/registrations' }
  devise_for :users, controllers: { sessions: 'users/sessions' }

  devise_scope :patient do
    resource :bedridden do
      get '/', as: :index, to: 'bedridden#index'
      put '/', as: :toggle, to: 'bedridden#toggle'
    end

    namespace :community do
      resources :appointments, only: %i[index create destroy] do
        collection do
          get :home
          get :vaccinated # not a collection one but due to the way we have appointments right now
        end
      end
    end
  end

  devise_scope :user do
    namespace :operator do
      resources :appointments, only: %i[index show] do
        member do
          patch :check_in
          patch :check_out
          patch :suspend
          patch :activate
        end

        collection do
          patch :suspend_future
          patch :activate_future
        end
      end

      resources :ubs, only: [:show] do
        member do
          patch :activate
          patch :suspend
        end
      end
    end
  end

  resources :patients

  post 'home/patient_base_login', as: :patient_base_login, to: 'home#patient_base_login'

  # FIXME: This is a temp method to allow the unblocking of a patient. We will use this route until we have the super-admin feature
  get 'Y29zaXNhbGVnYWxwb3JmYXZvcm5hb3RlbnRlbGVyCg/:cpf', to: 'home#unblock'

  get 'cadastrar_paciente/:cpf', to: 'home#register_patient'

  root 'home#index'
end
