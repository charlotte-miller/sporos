# =============================================================
# = NOTE: From gem 'acts_as_commentable_with_threading' 2.0.0 =
# =============================================================

require 'awesome_nested_set'
ActiveRecord::Base.class_eval do
  include CollectiveIdea::Acts::NestedSet
end

#
unless ActiveRecord::Base.respond_to?(:acts_as_nested_set)
  ActiveRecord::Base.send(:include, CollectiveIdea::Acts::NestedSet::Base)
end


module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comment_threads, ->{ order(created_at: :asc) }, :class_name => "Comment", :as => :commentable
    accepts_nested_attributes_for :comment_threads,
      reject_if: proc{|attrs| attrs['body'].blank? && attrs['title'].blank? },
      allow_destroy: true

    before_destroy { |record| record.root_comments.destroy_all }
  end

  # Helper method to display only root threads, no children/replies
  def root_comments
    self.comment_threads.where(:parent_id => nil)
  end

  # Helper method to sort comments by date
  def comments_ordered_by_submitted
    Comment.where(:commentable_id => id, :commentable_type => self.class.name).order('created_at DESC')
  end

  # Helper method that defaults the submitted time.
  def add_comment(comment)
    comment_threads << comment
  end

  module ClassMethods
    # Helper method to lookup for comments for a given object.
    # This method is equivalent to obj.comments.
    def find_comments_for(obj)
      Comment.where(:commentable_id => obj.id, :commentable_type => obj.class.base_class).order('created_at DESC')
    end

    # Helper class method to lookup comments for
    # the mixin commentable type written by a given user.
    # This method is NOT equivalent to Comment.find_comments_for_user
    def find_comments_by_user(user)
      commentable = self.base_class.name.to_s
      Comment.where(:user_id => user.id, :commentable_type => commentable).order('created_at DESC')
    end
  end

end
