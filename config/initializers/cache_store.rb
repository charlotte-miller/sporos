# Use Redis for Rails.cache
Rails.application.config.cache_store = :redis_store, "#{AppConfig.redis.url}/0/cache", { expires_in: 1.week }