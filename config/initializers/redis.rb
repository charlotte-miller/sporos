# Use Redis for Rails.cache
Rails.application.config.cache_store = :redis_store, "redis://#{AppConfig.redis.host}:#{AppConfig.redis.port}/0/cache", { expires_in: 90.minutes }