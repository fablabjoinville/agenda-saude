module SlackNotifier
  class << self
    mattr_accessor :slack_webhook_url

    def error(message)
      send_message("‼️ #{message}")
    end

    def info(message)
      send_message("ℹ️ #{message}")
    end

    def warn(message)
      send_message("⚠️ #{message}")
    end

    def success(message)
      send_message("✅ #{message}")
    end

    def send_message(text)
      return if slack_webhook_url.blank?

      uri = URI(slack_webhook_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request.body = { text: text }.to_json

      https.request(request)
    end
  end 
end
