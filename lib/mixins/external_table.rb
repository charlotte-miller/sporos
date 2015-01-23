# Usage:
# class LegacyTables < ActiveRecord::Base
#   include ExternalTable
#   db_setup "cornerstone_sf_org"
#   ...
# end

module ExternalTable
  extend ActiveSupport::Concern
  module ClassMethods
    def db_setup(db_config_name, table_name=self.table_name)
      establish_connection db_config_name
      self.table_name = table_name
    end
    
    def delete_all
      raise ActiveRecord::ReadOnlyRecord
    end
  end
  
  
  # ==========================================================================
  # =   Prevent creation, destruction, or modification to existing records   =
  # ==========================================================================
  def readonly?
    true
  end

  def before_destroy
    raise ActiveRecord::ReadOnlyRecord
  end
end