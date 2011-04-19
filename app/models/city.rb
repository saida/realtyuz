class City < ActiveRecord::Base
  belongs_to :region
  has_many :districts
  has_many :properties
  has_many :schools
  has_many :metros
  has_many :agencies
  
  attr_accessible :city_name, :region_id
  
  validates_presence_of   :region_id, :message => "Please select a region"
  validates_presence_of   :city_name, :message => "Please enter city name"
  validates_uniqueness_of :city_name, :message => "Such city already exists"
end
