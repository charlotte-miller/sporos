require 'rack/mime'
require 'ostruct'

module Rack
  class Rewrite
    class LegacyRedirects
      attr_reader :rules
      
      # :r301 moved permanently
      # :r302 found
      # :r303 see other
      # :r307 temporary redirect
      REDIRECT_METHOD = :r302  #r301 after launch

      def initialize(options)
        @options = options
        @rules = generate_rules(collect_redirects)
      end

      def collect_redirects
        load_page_rules #+
        # load_media_rules
      end

      def generate_rules(redirect_collection)
        redirect_collection.map do |redirect|
          Rule.new(REDIRECT_METHOD, redirect.from, redirect.to, @options)
        end
      end
      
    private
      def load_page_rules
        if Page.table_exists? 
          Page.all.map do |page|
            OpenStruct.new({
              from: page.legacy_url,
              to:   "/pages/#{page.to_param}" #hardcoded because url helpers aren't loaded
            })
          end
        else
          []
        end
      end
      
      def load_media_rules
        #todo 
      end

    end
  end
end