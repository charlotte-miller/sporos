class AddColumnsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :type, :text, null: false
    add_reference :groups, :study, index: true
    add_foreign_key :groups, :studies
    add_column :groups, :approved_at, :datetime
    add_attachment :groups, :poster_img
    add_column :groups, :poster_img_fingerprint, :string
    add_column :groups, :poster_img_processing, :boolean
    add_column :groups, :study_group_data, :jsonb, default: '{}', null: false
    add_column :groups, :book_group_data, :jsonb, default: '{}', null: false
    add_column :groups, :affinity_group_data, :jsonb, default: '{}', null: false

    add_index :groups, [:type, :id]
  end

end
