class Ptype < ActiveRecord::Base
  has_many :properties
  
  attr_accessible :ptype_name, :description
  
  validates_presence_of :ptype_name, :message => "Name must be provided"
  
end
