# https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-rails#rake-tasks
require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do
  
  desc "Downloads the WordNet 3.0 synonyms database for Searchkick - might require sudo privlages for /var/lib"
  task :download_wordnet do
    [
      'cd /tmp && curl -o wordnet.tar.gz http://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz',
      'cd /tmp && tar -zxvf wordnet.tar.gz',
      'cd /tmp && mv prolog/wn_s.pl /var/lib'
    ].each { |command| system(command) || raise( RuntimeError.new("FAILED TO EXECUTE: '#{command}'" )) }
  end
  
end