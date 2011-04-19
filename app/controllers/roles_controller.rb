class RolesController < ApplicationController
  layout 'admin'
  before_filter :check_administrator_role
  
  # GET /roles
  def index
    @account = Account.find(params[:account_id])
    @roles = Role.all
    @available_roles = @roles - @account.roles
  end
  
  def new
    @role = Role.new
  end
  
  def create
    @role = Role.new(params[:role])
    
    respond_to do |format|
      if @role.save
        format.html { redirect_to(accounts_path, :notice => 'Role was successfully created.') }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end
  # PUT /roles/1
  def update
    @account = Account.find(params[:account_id])
    @role = Role.find(params[:id])
    
    unless @account.has_role?(@role.name)
      @account.roles << @role
    end
    redirect_to :action => 'index'
  end
  
  def assign
    @account = Account.find(params[:account_id])
    @role = Role.find(params[:id])
    @account.roles << @role unless @account.has_role?(@role.name)
    
    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to(account_roles_url @account ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def unassign
    @account = Account.find(params[:account_id])
    @role = Role.find(params[:id])
    @account.roles.delete(@role) if @account.has_role?(@role.name)
    
    respond_to do |format|
      format.html { redirect_to(account_roles_url @account) }
      format.xml  { head :ok }
    end
  end

  # DELETE /roles/1
  def destroy
    @account = Account.find(params[:account_id])
    @role = Role.find(params[:id])
  
    if @account.has_role?(@role.name)
      @account.roles.delete(@role)
    end
    redirect_to :action => 'index'
  end
end
