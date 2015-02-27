# Typhoeus::USER_AGENT = AppConfig.crawler_user_agent

# Searchkick - https://github.com/ankane/searchkick#performance
require "typhoeus/adapters/faraday"
Ethon.logger = Logger.new("/dev/null")