class Metro < ActiveRecord::Base
  has_many    :metro_properties
  has_many    :properties, :through => :metro_properties
  belongs_to  :region
  belongs_to  :city
  belongs_to  :district
end
