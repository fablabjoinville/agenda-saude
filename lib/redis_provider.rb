module RedisProvider
  def self.present?
    redis_provider.present? && redis_url.present?
  end

  def self.redis
    return nil unless present? # rubocop:disable Rails/Blank

    @redis ||= Redis.new(url: redis_url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
  end

  def self.redis_provider
    ENV['REDIS_PROVIDER']
  end

  def self.redis_url
    ENV[redis_provider]
  end
end
