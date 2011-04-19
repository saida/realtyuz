class MyListingsProperty < ActiveRecord::Base
  belongs_to  :my_listings
  belongs_to  :property
  
  def ptype
    self.property.ptype.ptype_name
  end
  
  def room
    if self.property.room
      self.property.room.name
    end
  end
  
  def region
    self.property.region.region_name
  end
  
  def city
    self.property.city.city_name
  end
  
  def district
    if self.property.district
      self.property.district.district_name
    end
  end
  
  def price
    self.property.price
  end
  
  def self.search(search, page)
    paginate(:per_page => 3, :page => page || 1,
             :order => 'created_at DESC',
             :conditions => search)
  end
end
