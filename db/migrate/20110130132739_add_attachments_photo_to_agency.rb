class AddAttachmentsPhotoToAgency < ActiveRecord::Migration
  def self.up
    add_column :agencies, :photo_file_name, :string
    add_column :agencies, :photo_content_type, :string
    add_column :agencies, :photo_file_size, :integer
    add_column :agencies, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :agencies, :photo_file_name
    remove_column :agencies, :photo_content_type
    remove_column :agencies, :photo_file_size
    remove_column :agencies, :photo_updated_at
  end
end
