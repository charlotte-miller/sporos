module Content
  include Searchable
  
  def self.table_name_prefix
    'content_'
  end
end
