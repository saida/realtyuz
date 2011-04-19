class Article < ActiveRecord::Base
  belongs_to    :account
  belongs_to    :art_category,
                :class_name => 'ArtCategory',
                :foreign_key => 'acategory_id'
                
  validates_presence_of :account, :content
  validates_presence_of :title, :message => "Please enter article title"
  validates_presence_of :art_category, :message => "Please select article category"
                
  attr_accessible :account_id, :acategory_id, :title, :content
end
