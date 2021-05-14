class ExceptionNotifierService
  def self.call(exception)
    raise exception if Rails.env.development?

    Sentry.capture_exception(exception)
  end
end
