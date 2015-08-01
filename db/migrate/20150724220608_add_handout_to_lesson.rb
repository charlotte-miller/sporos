class AddHandoutToLesson < ActiveRecord::Migration
  def change
    add_attachment :lessons, :handout
    add_column     :lessons, :handout_original_url, :text
    add_column     :lessons, :handout_fingerprint, :text
    add_column     :lessons, :handout_processing, :boolean
  end
end
