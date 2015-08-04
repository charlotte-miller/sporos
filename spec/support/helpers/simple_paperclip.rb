# == Paperclip without ActiveRecord
#
# Simple and lightweight object that can use Paperclip
#
#
# Customized part can be extracted in another class which
# would inherit from SimplePaperclip.
#
#   class MyClass < SimplePaperclip
#     attr_accessor :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :id
#     has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
#     do_not_validate_attachment_file_type :image
#   end
#
# author : Bastien Gysler <basgys@gmail.com>
# https://gist.github.com/basgys/5712426
class SimplePaperclip
  extend ActiveModel::Callbacks
  include ActiveModel::Model
  include Paperclip::Glue

  # Paperclip required callbacks
  define_model_callbacks :save, only: [:after]
  define_model_callbacks :commit, only: [:after]
  define_model_callbacks :destroy, only: [:before, :after]

  def save
    run_callbacks :save do
      self.id = 1000 + Random.rand(9000)
    end
    return true
  end

  def destroy
    run_callbacks :destroy
  end

  def updated_at_short
    return Time.now.to_s(:autosave_time)
  end

  def errors
    obj = Object.new
    def obj.[](key)         [] end
    def obj.full_messages() [] end
    def obj.any?()       false end
    obj
  end
end
