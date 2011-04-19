class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes, :force => true do |t|
      t.integer :vote, :default => 0
      t.datetime :created_at, :null => false
      t.string :voteable_type, :limit => 15, :default => "", :null => false
      t.integer :voteable_id, :default => 0, :null => false
      t.integer :account_id, :default => 0, :null => false
  end

  add_index :votes, ["account_id"], :name => "fk_votes_account"
  end

  def self.down
    drop_table :votes
  end
end
