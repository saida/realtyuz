class Material < ActiveRecord::Base
  has_many :properties
  
  validates_presence_of :name, :message => "Please enter material name"
end
