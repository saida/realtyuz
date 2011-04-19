class AddStypeToSchools < ActiveRecord::Migration
  def self.up
    add_column :schools, :stype, :string
  end

  def self.down
    remove_column :schools, :stype
  end
end
