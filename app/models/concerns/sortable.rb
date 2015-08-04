# === Adds acts_as_list, a default scope, and a comparitor
#
module Sortable
  extend ActiveSupport::Concern

  included do
    include Comparable
    default_scope -> {order 'position ASC'}
  end

  module ClassMethods

    def acts_as_listable options={}
      class_eval do
        acts_as_list options
      end
    end
  end

  # "Higher" means further up the list (a lesser position)
  # "Lower" means further down the list (a greater position)
  def <=>(other)
    unless scope_name == "1 = 1" # not scoped
      unless self.send(scope_name) == other.send(scope_name)
        raise ArgumentError.new("Can't compare across scopes")
      end
    end
    other.position <=> position
  end
end
