class CreateArtCategories < ActiveRecord::Migration
  def self.up
    create_table :art_categories do |t|
      t.text :name

      t.timestamps
    end
  end

  def self.down
    drop_table :art_categories
  end
end
