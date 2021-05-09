require 'redis_provider'

RedisProvider.redis if RedisProvider.present?
