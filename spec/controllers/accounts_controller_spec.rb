require File.dirname(__FILE__) + '/../spec_helper'
  
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.


describe AccountsController do
  include AuthenticatedTestHelper
  fixtures :accounts

  it 'allows signup' do
    lambda do
      create_account
      response.should be_redirect
    end.should change(Account, :count).by(1)
  end

  
  it 'signs up user in pending state' do
    create_account
    assigns(:account).reload
    assigns(:account).should be_pending
  end

  it 'signs up user with activation code' do
    create_account
    assigns(:account).reload
    assigns(:account).activation_code.should_not be_nil
  end
  it 'requires login on signup' do
    lambda do
      create_account(:login => nil)
      assigns[:account].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_account(:password => nil)
      assigns[:account].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_account(:password_confirmation => nil)
      assigns[:account].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_account(:email => nil)
      assigns[:account].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end
  
  
  it 'activates user' do
    Account.authenticate('aaron', 'monkey').should be_nil
    get :activate, :activation_code => accounts(:aaron).activation_code
    response.should redirect_to('/login')
    flash[:notice].should_not be_nil
    flash[:error ].should     be_nil
    Account.authenticate('aaron', 'monkey').should == accounts(:aaron)
  end
  
  it 'does not activate user without key' do
    get :activate
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  it 'does not activate user with blank key' do
    get :activate, :activation_code => ''
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  it 'does not activate user with bogus key' do
    get :activate, :activation_code => 'i_haxxor_joo'
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  def create_account(options = {})
    post :create, :account => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end

describe AccountsController do
  describe "route generation" do
    it "should route accounts's 'index' action correctly" do
      route_for(:controller => 'accounts', :action => 'index').should == "/accounts"
    end
    
    it "should route accounts's 'new' action correctly" do
      route_for(:controller => 'accounts', :action => 'new').should == "/signup"
    end
    
    it "should route {:controller => 'accounts', :action => 'create'} correctly" do
      route_for(:controller => 'accounts', :action => 'create').should == "/register"
    end
    
    it "should route accounts's 'show' action correctly" do
      route_for(:controller => 'accounts', :action => 'show', :id => '1').should == "/accounts/1"
    end
    
    it "should route accounts's 'edit' action correctly" do
      route_for(:controller => 'accounts', :action => 'edit', :id => '1').should == "/accounts/1/edit"
    end
    
    it "should route accounts's 'update' action correctly" do
      route_for(:controller => 'accounts', :action => 'update', :id => '1').should == {:path => "/accounts/1", :method => :put}
    end
    
    it "should route accounts's 'destroy' action correctly" do
      route_for(:controller => 'accounts', :action => 'destroy', :id => '1').should == {:path => "/accounts/1", :method => :delete}
    end
  end
  
  describe "route recognition" do
    it "should generate params for accounts's index action from GET /accounts" do
      params_from(:get, '/accounts').should == {:controller => 'accounts', :action => 'index'}
      params_from(:get, '/accounts.xml').should == {:controller => 'accounts', :action => 'index', :format => 'xml'}
      params_from(:get, '/accounts.json').should == {:controller => 'accounts', :action => 'index', :format => 'json'}
    end
    
    it "should generate params for accounts's new action from GET /accounts" do
      params_from(:get, '/accounts/new').should == {:controller => 'accounts', :action => 'new'}
      params_from(:get, '/accounts/new.xml').should == {:controller => 'accounts', :action => 'new', :format => 'xml'}
      params_from(:get, '/accounts/new.json').should == {:controller => 'accounts', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for accounts's create action from POST /accounts" do
      params_from(:post, '/accounts').should == {:controller => 'accounts', :action => 'create'}
      params_from(:post, '/accounts.xml').should == {:controller => 'accounts', :action => 'create', :format => 'xml'}
      params_from(:post, '/accounts.json').should == {:controller => 'accounts', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for accounts's show action from GET /accounts/1" do
      params_from(:get , '/accounts/1').should == {:controller => 'accounts', :action => 'show', :id => '1'}
      params_from(:get , '/accounts/1.xml').should == {:controller => 'accounts', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/accounts/1.json').should == {:controller => 'accounts', :action => 'show', :id => '1', :format => 'json'}
    end
    
    it "should generate params for accounts's edit action from GET /accounts/1/edit" do
      params_from(:get , '/accounts/1/edit').should == {:controller => 'accounts', :action => 'edit', :id => '1'}
    end
    
    it "should generate params {:controller => 'accounts', :action => update', :id => '1'} from PUT /accounts/1" do
      params_from(:put , '/accounts/1').should == {:controller => 'accounts', :action => 'update', :id => '1'}
      params_from(:put , '/accounts/1.xml').should == {:controller => 'accounts', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/accounts/1.json').should == {:controller => 'accounts', :action => 'update', :id => '1', :format => 'json'}
    end
    
    it "should generate params for accounts's destroy action from DELETE /accounts/1" do
      params_from(:delete, '/accounts/1').should == {:controller => 'accounts', :action => 'destroy', :id => '1'}
      params_from(:delete, '/accounts/1.xml').should == {:controller => 'accounts', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/accounts/1.json').should == {:controller => 'accounts', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route accounts_path() to /accounts" do
      accounts_path().should == "/accounts"
      accounts_path(:format => 'xml').should == "/accounts.xml"
      accounts_path(:format => 'json').should == "/accounts.json"
    end
    
    it "should route new_account_path() to /accounts/new" do
      new_account_path().should == "/accounts/new"
      new_account_path(:format => 'xml').should == "/accounts/new.xml"
      new_account_path(:format => 'json').should == "/accounts/new.json"
    end
    
    it "should route account_(:id => '1') to /accounts/1" do
      account_path(:id => '1').should == "/accounts/1"
      account_path(:id => '1', :format => 'xml').should == "/accounts/1.xml"
      account_path(:id => '1', :format => 'json').should == "/accounts/1.json"
    end
    
    it "should route edit_account_path(:id => '1') to /accounts/1/edit" do
      edit_account_path(:id => '1').should == "/accounts/1/edit"
    end
  end
  
end
