class Property < ActiveRecord::Base
  acts_as_polymorphic_paperclip(:styles => {:tiny => "70x55#", :small => "160x120>", :large => "560x420>"})
  acts_as_commentable
  acts_as_voteable
  
  has_many    :my_listings_properties
  has_many    :school_properties
  has_many    :metro_properties
  has_many    :my_listings,         :through => :my_listings_properties
  has_many    :accounts,            :through => :my_listings
  has_many    :schools,             :through => :school_properties
  has_many    :metros,              :through => :metro_properties
  belongs_to  :room
  belongs_to  :ptype
  belongs_to  :category
  belongs_to  :region
  belongs_to  :city
  belongs_to  :district
  belongs_to  :material
  belongs_to  :account,
              :class_name => "Account",
              :foreign_key => "seller_id",
              :conditions => "email is not null"
  
  validates_presence_of         :ptype, :region, :city, :price
  validates_numericality_of     :area, :allow_nil => true
  validates_numericality_of     :floor, :allow_nil => true
  validates_numericality_of     :floors, :allow_nil => true
  validates_numericality_of     :price
  validate                      :price_must_be_at_least_a_dollar
  accepts_nested_attributes_for :assets, :allow_destroy => true
  accepts_nested_attributes_for :metro_properties, :allow_destroy => true
  accepts_nested_attributes_for :school_properties, :allow_destroy => true
  
  def self.search(search, page, order)
    paginate(:per_page => 8, :page => page || 1,
             :order => order,
             :include => [:ptype, :region, :city, :district],
             :conditions => search)
  end
  
protected
  def price_must_be_at_least_a_dollar
    errors.add(:price, 'should be at least 1') if price.nil? || price < 1
  end
  
end
