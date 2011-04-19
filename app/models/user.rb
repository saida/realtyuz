require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :properties, :through => :accounts
  has_many :properties, :through => :my_listings
  has_many :accounts
  has_many :roles, :through => :accounts
  belongs_to :agency
  belongs_to :user,
             :class_name => "User",
             :foreign_key => "broker_id",
             :conditions => "utype_id is not null"
  belongs_to :utype
  before_save :clear_photo
  has_attached_file :photo,
                    :styles => { :small => "70x55>", :large => "150x150>" },
                    :url => "/realestate/users/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/realestate/users/:id/:style/:basename.:extension"
  #validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => [ 'image/jpeg', 'image/png' ]
  
  accepts_nested_attributes_for :accounts, :allow_destroy => true
  
  validates_presence_of :email
  validates_uniqueness_of :email
  # validates_length_of :email, :within => 6..50  

  def after_destroy
   if User.count.zero?
     raise "Can't delete last user"
   end
  end

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
