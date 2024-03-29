class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      # Greetings
      t.string :first_name, :limit => 60
      t.string :last_name,  :limit => 60
      t.string :public_id,  :limit => 20

      ## Database authenticatable
      t.string :email,              :null => false, :default => "", :limit => 80
      t.string :encrypted_password, :null => false, :default => ""
      t.boolean :admin,                             :default => false

      ## Encryptable
      t.string :password_salt

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0
      t.datetime :locked_at
      t.string   :unlock_token # Only if unlock strategy is :email or :both

      ## Profile Image
      t.attachment :profile_image
      t.string     :profile_image_fingerprint
      t.boolean    :profile_image_processing

      t.timestamps  null: false
    end

    add_index :users, :email,                  unique: true
    add_index :users, :reset_password_token,   unique: true
    add_index :users, :confirmation_token,     unique: true
    add_index :users, :public_id,  length:20,  unique: true
    add_index :users, :unlock_token,           unique: true
  end
end
