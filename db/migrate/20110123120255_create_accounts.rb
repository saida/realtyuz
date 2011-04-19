class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table "accounts", :force => true do |t|
      t.string   :login,                     :limit => 40
      t.string   :name,                      :limit => 100, :default => '', :null => true
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at
      t.string   :state,                     :null => :no, :default => 'passive'
      t.string   :password_reset_code,       :limit => 40
      t.integer  :enabled,                   :default => 1
      t.datetime :deleted_at
    end
    add_index :accounts, :login, :unique => true
  end

  def self.down
    drop_table "accounts"
  end
end
