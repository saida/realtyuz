class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t| 
    t.string    :title,             :limit => 50,   :default => "" 
    t.string    :comment,           :default => "" 
    t.datetime  :created_at,        :null => false 
    t.integer   :commentable_id,    :default => 0,  :null => false 
    t.string    :commentable_type,  :limit => 15,   :default => "", :null => false 
    t.integer   :account_id,        :default => 0,  :null => false
  end
  
  add_index :comments, ["account_id"], :name => "fk_comments_account"
  end
  
  def self.down
    drop_table :comments
  end
end
