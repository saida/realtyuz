class Preference < ActiveRecord::Base
  belongs_to  :room
  belongs_to  :ptype
  belongs_to  :category, :foreign_key => 'pcategory_id'
  belongs_to  :region
  belongs_to  :city
  belongs_to  :district
  belongs_to  :material
  belongs_to  :account,
              :class_name => "Account",
              :foreign_key => "user_id",
              :conditions => "email is not null"
  
  validates_numericality_of     :minarea, :allow_nil => true
  validates_numericality_of     :maxarea, :allow_nil => true
  validates_numericality_of     :floor, :allow_nil => true
  validates_numericality_of     :floors, :allow_nil => true
  validates_numericality_of     :minprice, :allow_nil => true
  validates_numericality_of     :maxprice, :allow_nil => true
  validate                      :price_must_be_at_least_a_dollar
  validate                      :max_value_should_be_more_than_min_value
  
protected
  def price_must_be_at_least_a_dollar
    errors.add(:maxprice, 'should be at least 1') if !maxprice.nil? && maxprice < 1
    errors.add(:minprice, 'should be at least 1') if !minprice.nil? && minprice < 1
  end
  
  def max_value_should_be_more_than_min_value
    errors.add(:maxprice, 'maximum price should be more than mimimum price') if !maxprice.nil? && !minprice.nil? && maxprice < minprice
    errors.add(:maxprice, 'maximum area should be more than minimum area') if !maxarea.nil? && !minarea.nil? && maxarea < minarea
  end
end
