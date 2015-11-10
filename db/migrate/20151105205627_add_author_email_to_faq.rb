class AddAuthorEmailToFaq < ActiveRecord::Migration
  def change
    add_column :faqs, :author_email, :string
    add_column :faqs, :author_email_body, :text
  end
end
