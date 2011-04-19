class Region < ActiveRecord::Base
  has_many :cities
  has_many :districts, :through => :cities
  has_many :properties
  has_many :schools
  has_many :metros
  has_many :agencies
  
  validates_presence_of   :region_name,
                          :message => "Please, enter region name"
  validates_uniqueness_of :region_name,
                          :message => "Such region already exists"
                          
end
