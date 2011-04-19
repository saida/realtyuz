class Document < ActiveRecord::Base
  belongs_to :account

  has_attached_file :doc,
                    :url => "/realestate/documents/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/realestate/documents/:id/:style/:basename.:extension"
  validates_attachment_presence :doc
  validates_attachment_size :doc, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => [ 'image/jpeg', 'image/png' ]
end