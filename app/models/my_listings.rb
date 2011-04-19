class MyListings < ActiveRecord::Base
  has_many    :my_listings_properties
  has_many    :properties, :through => :my_listings_properties
  belongs_to  :account
end
