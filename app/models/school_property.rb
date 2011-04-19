class SchoolProperty < ActiveRecord::Base
  belongs_to :school
  belongs_to :property
  belongs_to :transport
end
