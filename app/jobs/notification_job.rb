class NotificationJob < ApplicationJob
  queue_as :default

  PREFIXES = {
    error: '‼️ ',
    info: 'ℹ️ ',
    warn: '⚠️ ',
    success: '✅ '
  }.freeze

  def perform(level, message)
    send_message "#{PREFIXES[level.to_sym]}#{message}"
  end

  class << self
    PREFIXES.each do |k, _|
      # Generates class methods for `NotificationJob.error(msg)`, `NotificationJob.info(msg)`, ...
      define_method k do |message|
        perform_later k.to_s, message
      end
    end
  end

  private

  class MissingWebhookUrl < StandardError; end

  def send_message(text)
    raise MissingWebhookUrl if ENV['SLACK_WEBHOOK_URL'].blank?

    uri = URI(ENV[:SLACK_WEBHOOK_URL])
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = { text: text }.to_json

    https.request(request)
  end
end
