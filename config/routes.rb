Rails.application.routes.draw do
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions', registrations: 'patients/registrations' }
  devise_for :users, path: 'users', controllers: { sessions: 'users/sessions' }

  devise_scope :patient do
    root 'home#index'
    get '/home_teste_rapido', to: 'home#home_teste_rapido'

    resource :time_slot do
      get '/', as: :index, to: 'time_slot#index'
      post '/', as: :schedule, to: 'time_slot#schedule'
      delete '/', as: :cancel, to: 'time_slot#cancel'
    end

    resource :bedridden do
      get '/', as: :index, to: 'bedridden#index'
      put '/', as: :toggle, to: 'bedridden#toggle'
    end
  end

  devise_scope :user do
    get 'ubs/active_hours', as: :ubs_active_hours
    patch 'ubs/change_active_hours', as: :ubs_change_active_hours

    get 'ubs/slot_duration', as: :ubs_slot_duration
    patch 'ubs/change_slot_duration', as: :ubs_change_slot_duration
  end

  resources :appointments
  resources :patients

  resources :ubs do
    member do
      get 'cancel_appointment'
      get 'activate_appointment'
      get 'cancel_all_future_appointments'
      get 'activate_all_future_appointments'
      get 'activate_ubs'
      get 'deactivate_ubs'
    end
  end

  post 'home/patient_base_login', as: :patient_base_login, to: 'home#patient_base_login'

  # FIXME: This is a temp method to allow the unblocking of a patient. We will use this route until we have the super-admin feature
  get 'Y29zaXNhbGVnYWxwb3JmYXZvcm5hb3RlbnRlbGVyCg/:cpf', to: 'home#unblock'

  get 'cadastrar_paciente/:cpf', to: 'home#register_patient'

end
