require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :patients, path: 'patients', controllers: { sessions: 'patients/sessions', registrations: 'patients/registrations' }
  devise_for :users, path: 'users', controllers: { sessions: 'users/sessions' }

  devise_scope :patient do
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

    get 'ubs/patient_checkin', as: :ubs_patient_checkin, to: 'ubs#patient_checkin'
    get 'ubs/patient_checkout', as: :ubs_patient_checkout, to: 'ubs#patient_checkout'
    get 'ubs/status', as: :status
    get 'ubs/checkin', as: :list_checkin
    post 'ubs/find_patients', as: :find_patients
    get 'ubs/checkout', as: :list_checkout
    get 'ubs/confirm_check_in', as: :confirm_check_in
    post 'ubs/confirm_check_out', as: :confirm_check_out
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
    end
  end

  post 'home/patient_base_login', as: :patient_base_login, to: 'home#patient_base_login'

  # FIXME: This is a temp method to allow the unblocking of a patient. We will use this route until we have the super-admin feature
  get 'Y29zaXNhbGVnYWxwb3JmYXZvcm5hb3RlbnRlbGVyCg/:cpf', to: 'home#unblock'

  get 'cadastrar_paciente/:cpf', to: 'home#register_patient'

  Sidekiq::Web.use Rack::Auth::Basic do |u, p|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(u),
                                                ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_ADMIN_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(p),
                                                  ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_ADMIN_PASSWORD"]))
  end
  mount Sidekiq::Web, at: "/sidekiq"

  root 'home#index'
end
