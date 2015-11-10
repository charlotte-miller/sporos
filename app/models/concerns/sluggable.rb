# === Adds FriendlyId and adds #slug_candidates interface
#
module Sluggable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    friendly_id :slug_candidates, use: [:slugged, :history]
    require 'protected_attributes'
    attr_protected :slug
  end

  module ClassMethods

    # Usage: slug_candidates :title, [:title, :church_name]
    # Becomes:
    #
    #   def slug_candidates
    #     [:title, [:title, :church_name]]
    #   end
    #
    def slug_candidates *args
      define_method(:slug_candidates) {args}
    end
  end

  # Canidate Helpers
  # Example: slug_candidates :title, [:title, :year], [:title, :month, :year]
  #
  def year
    (created_at || Time.now).year
  end

  def month
    (created_at || Time.now).strftime("%B")
  end

  def date
    (created_at || Time.now).day
  end
end
