class District < ActiveRecord::Base
  belongs_to  :city
  has_many    :properties
  has_many    :schools
  has_many    :metros
  has_many    :agencies
  
  validates_presence_of :city_id, :district_name
  validates_uniqueness_of :district_name,
                          :message => "Such district is already in the system"
end
