class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.references :faq_answer, index:true
      t.text :body, null:false

      t.timestamps null: false
    end
  end
end
