module RedisProvider
  def self.present?
    redis_provider.present? && redis_url.present?
  end

  def self.redis
    return nil if blank?

    @redis ||= Redis.new(url: redis_url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
  end

  def self.redis_provider
    ENV['REDIS_PROVIDER'] # rubocop:disable Rails/EnvironmentVariableAccess
  end

  def self.redis_url
    ENV[redis_provider] # rubocop:disable Rails/EnvironmentVariableAccess
  end
end
