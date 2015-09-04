class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.text :question_variants, array:true, default:[]
      t.text :answer, null:false
      t.text :more_info_path

      t.timestamps null: false
    end
  end
end
