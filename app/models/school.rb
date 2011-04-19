class School < ActiveRecord::Base
  has_many    :school_properties
  has_many    :properties, :through => :school_properties
  belongs_to  :region
  belongs_to  :city
  belongs_to  :district
end
