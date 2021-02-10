Rails.application.routes.draw do
  get 'admin/index'
  devise_for :admins, path: 'admin', controllers: { sessions: 'admin/sessions' }
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions', registrations: 'patients/registrations' }
  devise_for :users, path: 'users', controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  devise_scope :admin do
    get 'admin/', to: 'admin#index'

    namespace :admin do
      resources :ubs do
        member do
          get 'activate'
          get 'deactivate'
        end
      end
    end
  end

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

    get 'ubs/patient_details', as: :ubs_patient_details, to: 'ubs#patient_details'
    get 'ubs/status', as: :status
    get 'ubs/checkin', as: :list_checkin
    post 'ubs/find_patients', as: :find_patients
    get 'ubs/checkout', as: :list_checkout
    get 'ubs/confirm_check_in', as: :confirm_check_in
    get 'ubs/confirm_check_out', as: :confirm_check_out
  end

  resources :appointments
  resources :patients

  resources :ubs do
    member do
      get 'suspend_appointment'
      get 'activate_appointment'
      get 'cancel_all_future_appointments'
      get 'activate_all_future_appointments'
      get 'activate_ubs'
      get 'deactivate_ubs'
      get 'today_appointments'
      get 'patient_details'
    end
  end

  post 'home/patient_base_login', as: :patient_base_login, to: 'home#patient_base_login'

  # FIXME: This is a temp method to allow the unblocking of a patient. We will use this route until we have the super-admin feature
  get 'Y29zaXNhbGVnYWxwb3JmYXZvcm5hb3RlbnRlbGVyCg/:cpf', to: 'home#unblock'

  get 'cadastrar_paciente/:cpf', to: 'home#register_patient'

end
