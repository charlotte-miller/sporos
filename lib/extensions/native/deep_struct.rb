# http://andreapavoni.com/blog/2013/4/create-recursive-openstruct-from-a-ruby-hash/
require 'ostruct'

class DeepStruct < OpenStruct

  def initialize(data=nil)
    @table = {}
    @hash_table = {}

    if data && defined? data.each
      @hash_table = data.deep_symbolize_keys

      data.each do |k,v|
        @table[k.to_sym] = case v
          when Hash
            self.class.new(v)
          when Array
            v.map do |val|
              if defined? val.each
                self.class.new(val)
              else
                val
              end
            end
          else
            v
        end

        new_ostruct_member(k)
      end
    else
      data
    end
  end

  def to_h
    @hash_table
  end

  def self.from_json(json_str)
    DeepStruct.new MultiJson.load(json_str)
  end
end
