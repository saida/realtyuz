class Agency < ActiveRecord::Base
  acts_as_commentable

  has_many :users
  belongs_to :region
  belongs_to :city
  belongs_to :district
  before_save :clear_photo
  has_attached_file :photo,
                    :styles => { :small => "70x55>", :large => "320x240>" },
                    :url => "/realestate/agencies/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/realestate/agencies/:id/:style/:basename.:extension"
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => [ 'image/jpeg', 'image/png' ]
  
  validates_presence_of :agency_name
  
  def delete_photo=(value)
   @delete_photo = !value.to_i.zero?
  end

  def delete_photo
   !!@delete_photo
  end
  
  alias_method :delete_photo?, :delete_photo

  def clear_photo
   self.photo = nil if delete_photo? && !photo.dirty?
  end
end
