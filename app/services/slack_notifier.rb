require 'concurrent'

module SlackNotifier
  mattr_accessor :slack_webhook_url

  class << self
    def error(message, async: true)
      send_message("‼️ #{message}", async: async)
    end

    def info(message, async: true)
      send_message("ℹ️ #{message}", async: async)
    end

    def warn(message, async: true)
      send_message("⚠️ #{message}", async: async)
    end

    def success(message, async: true)
      send_message("✅ #{message}", async: async)
    end

    def send_message(text, async: true)
      return if slack_webhook_url.blank?

      if async
        pool.post { do_send_message(text) }
      else
        do_send_message(text)
      end
    end

    private

    def do_send_message(text)
      uri = URI(slack_webhook_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request.body = { text: text }.to_json

      https.request(request)
    end

    # A thread pool seems overkill, but the idea here is just
    # to allow async execution of slack notifications without
    # creating a new thread for every notification. Async
    # execution is important because we don't want any Slack
    # server instability to impact critical sections of the code.
    def pool
      @pool ||= Concurrent::FixedThreadPool.new(1)
    end
  end
end
