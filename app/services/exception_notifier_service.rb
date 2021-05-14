class ExceptionNotifierService
  def self.call(exception)
    raise exception if Rails.env.development?

    Appsignal.send_error(exception)
  end
end
