class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer       :study_id,        null: false
      t.integer       :position,        default: 0
      t.string        :title,           null: false
      t.text          :description
      t.string        :author
      t.string        :backlink
      t.attachment    :poster_img
      t.string        :poster_img_original_url
      t.string        :poster_img_fingerprint
      t.boolean       :poster_img_processing
      t.string        :video_vimeo_id
      t.attachment    :video
      t.string        :video_original_url
      t.string        :video_fingerprint
      t.boolean       :video_processing
      t.attachment    :audio
      t.string        :audio_original_url
      t.string        :audio_fingerprint
      t.boolean       :audio_processing
      t.boolean       :machine_sorted,  default: false
      t.integer       :duration #in seconds
      t.datetime      :published_at
      t.timestamps                      null: false
    end

    add_index :lessons, [:study_id, :position]
    add_index :lessons, :backlink
    add_index :lessons, :video_vimeo_id, unique:true
  end
end
