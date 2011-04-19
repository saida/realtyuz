class Transport < ActiveRecord::Base
  has_many :metro_properties
  has_many :school_properties
end
