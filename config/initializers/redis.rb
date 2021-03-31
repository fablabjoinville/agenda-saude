$redis = Redis.new(url: ENV[ENV["REDIS_PROVIDER"]], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
