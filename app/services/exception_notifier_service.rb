class ExceptionNotifierService < ApplicationService
  def initialize(exception)
    @exception = exception

    super()
  end

  def call
    raise @exception if Rails.env.development?

    Sentry.capture_exception(e)
  end
end
