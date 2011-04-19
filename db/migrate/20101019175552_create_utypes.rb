class CreateUtypes < ActiveRecord::Migration
  def self.up
    create_table :utypes do |t|
      t.string :usertype
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :utypes
  end
end
