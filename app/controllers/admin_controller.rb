class AdminController < ApplicationController
  layout "admin"
  before_filter :login_required
  before_filter :check_administrator_role

  def index
    report
    latest_comments
    @properties = Property.all(:order => 'created_at DESC')
  end
  
  # http://stackoverflow.com/questions/2440957/graphing-new-users-by-date-in-a-rails-app-using-seer
  # declare a struct to hold the results
  AccountCountByDate = Struct.new(:date, :count)
  PropertyCountByDate = Struct.new(:date, :count)
  PreferenceCountByDate = Struct.new(:date, :count)
  PropertyCountByRegion = Struct.new(:name, :count)
  
  def report
    @account_report = Ezgraphix::Graphic.new(:w => 300, :h => 250, :c_type => 'col3d', :div_name => 'account_counts', :values => 0, :background => 'ececec', :precision => 0 )
    
    @account_report.data = Account.count( :group => "DATE(created_at)", 
                                      #:conditions => ["created_at >= ? ", 30.days.ago], 
                                      :order => "DATE(created_at) ASC"
                                    ).collect do |date, count| 
                                      AccountCountByDate.new(Date.strptime(date, "%Y-%m-%d").strftime("%e %b"), count)
                                    end
    
    @account_report.labels = @account_report.data.collect{|a| a.date}
                                    
    @property_report = Ezgraphix::Graphic.new(:w => 300, :h => 250, :c_type => 'col3d', :div_name => 'property_counts', :values => 0, :background => 'ececec', :precision => 0)
                                    
    @property_report.data = Property.count( :group => "DATE(created_at)",
                                        :conditions => ["created_at >= ? ", 30.days.ago], 
                                        :order => "DATE(created_at) ASC"
                                      ).collect do |date, count|
                                        PropertyCountByDate.new(Date.strptime(date, "%Y-%m-%d").strftime("%e %b"), count)
                                      end
    @property_report.labels = @property_report.data.collect{|p| p.date}


    @preference_report = Ezgraphix::Graphic.new(:w => 300, :h => 250, :c_type => 'col3d', :div_name => 'preference_counts', :values => 0, :background => 'ececec', :precision => 0)
    @preference_report.data = Preference.count( :group => "DATE(created_at)",
                                        :conditions => ["created_at >= ? ", 30.days.ago], 
                                        :order => "DATE(created_at) ASC"
                                      ).collect do |date, count|
                                        PreferenceCountByDate.new(Date.strptime(date, "%Y-%m-%d").strftime("%e %b"), count)
                                      end
    @preference_report.labels = @preference_report.data.collect{|p| p.date}


    @regions_report = Ezgraphix::Graphic.new(:w => 300, :h => 250, :c_type => 'pie3d', :div_name => 'regions_counts', :values => 0, :background => 'ececec', :precision => 0)
    @regions_report.data = Property.count( :group => "r.region_name",
                                        :joins => "Join regions r on r.id = properties.region_id",
                                        :order => "r.region_name"
                                      ).collect do |r_name, count|
                                        PropertyCountByRegion.new(r_name, count)
                                      end
    @regions_report.labels = @regions_report.data.collect{|p| p.name}
  end
  
  def latest_comments
    @comments = Comment.all.reverse[0..4]
  end
end
