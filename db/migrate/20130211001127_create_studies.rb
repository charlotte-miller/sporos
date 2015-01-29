class CreateStudies < ActiveRecord::Migration
  def change
    create_table    :studies do |t|
      t.string      :slug,          null:false
      t.integer     :channel_id,    null:false
      t.integer     :podcast_id,    null:false
      t.string      :title,         null:false
      t.text        :description
      t.text        :keywords     #array: true, default: []
      t.string      :ref_link
      t.attachment  :poster_img
      t.string      :poster_img_original_url
      t.string      :poster_img_fingerprint
      t.boolean     :poster_img_processing
      t.integer     :lessons_count, default: 0
                    
      t.datetime    :last_published_at
      t.timestamps  null: false
    end
    
    add_index :studies, :slug, unique: true
    add_index :studies, [:podcast_id, :last_published_at]
    add_index :studies, :last_published_at
  end
end
