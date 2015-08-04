custom_web: bundle exec unicorn_rails -c config/unicorn.rb -E $RAILS_ENV -D
worker: bundle exec rake resque:work QUEUE=*
# worker: QUEUE=* bundle exec rake resque:work
# scheduler: bundle exec rake resque:scheduler
