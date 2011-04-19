class InfoController < ApplicationController
  def who_added
    @property = Property.find[params[:id]]
    @users = @property.users
    respond_to do |format|
      format.html
      format.xml { render :xml => @product.to_xml(:include => :users) }
    end
  end

protected

def authorize
end
end
