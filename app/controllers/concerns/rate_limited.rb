module RateLimited
  extend ActiveSupport::Concern

  def rate_limit!
    render plain: I18n.t('alerts.rate_limit_exceeded'), status: :too_many_requests
  end

  def exceeded_rate_limit?
    return false unless RedisProvider.redis

    RedisProvider.redis.get(rate_limit_key).to_i > Rails.configuration.x.rate_limit_per_minute
  end

  def rate_limit_key
    @rate_limit_key ||= ['rl', current_patient.id, Time.zone.now.strftime('%M')].join(':')
  end

  def record_on_rate_limit
    RedisProvider.redis&.multi do
      RedisProvider.redis.incr rate_limit_key
      RedisProvider.redis.expire rate_limit_key, 59
    end
  end
end
