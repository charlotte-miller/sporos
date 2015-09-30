class CreateFaqAnswers < ActiveRecord::Migration
  def change
    create_table :faq_answers do |t|
      t.references :user, index:true
      t.text :body
      t.text :more_info_path

      t.timestamps null: false
    end
  end
end
