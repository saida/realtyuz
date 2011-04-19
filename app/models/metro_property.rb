class MetroProperty < ActiveRecord::Base
  belongs_to :metro
  belongs_to :property
  belongs_to :transport
end
