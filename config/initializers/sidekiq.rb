SIDEKIQ_REDIS_CONFIGURATION = {
  url: ENV[ENV["SIDEKIQ_REDIS_PROVIDER"]], # env var that points to the correct env var
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }, # we must trust Heroku and AWS here
}

Sidekiq.configure_server do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end

Sidekiq.configure_client do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end
