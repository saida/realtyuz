class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :account_id
      t.integer :acategory_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
