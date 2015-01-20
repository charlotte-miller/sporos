Resque.logger = MonoLogger.new(File.open("#{Rails.root}/log/resque.log", "w+"))
Resque.logger.formatter = Resque::QuietFormatter.new
# Resque.logger.formatter = Resque::VerboseFormatter.new
# Resque.logger.formatter = Resque::VeryVerboseFormatter.new

Resque.redis.namespace = "cornerstone:sporos"

require 'yaml'
require 'resque-scheduler'
# Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/resque_schedule.yml')) # load the schedule