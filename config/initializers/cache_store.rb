# Use Redis for Rails.cache
Rails.application.config.cache_store = :redis_store, "#{AppConfig.redis.host}/0/cache", { expires_in: 90.minutes }