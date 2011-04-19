ActionController::Routing::Routes.draw do |map|
  map.resources :documents

  map.resources :preferences

  map.resources :materials

  map.resources :art_categories

  map.resources :articles

  map.resources :metro_properties

  map.resources :metros

  map.resources :transports

  map.resources :school_properties

  map.resources :schools

  map.resources :roles

  map.resources :pictures

  map.resources :categories

  map.resources :agencies

  map.resources :rooms

  map.resources :photos

  map.resources :utypes

  map.resources :users

  map.resources :districts

  map.resources :cities

  map.resources :regions

  map.resources :ptypes

  map.resources :properties
  
  map.resources :accounts, :member => { :suspend   => :put,
                                        :unsuspend => :put,
                                        :purge     => :delete,
                                        :enable    => :put } do |accounts|

    accounts.resource :profile
  
    accounts.resources :roles, :member => { :assign => [:put, :get], :unassign => :delete }
    
  end
  
  map.resource :session, :member => { :new    => :post,
                                      :update => :post}
 
  map.resource :password, :member => { :new    => :post,
                                       :update => :post}

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => 'realestate', :action => 'index'

  # See how all your routes lay out with "rake routes"
  map.resources :pages

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.signup  '/signup', :controller => 'accounts', :action => 'new'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.change_password '/change_password', :controller => 'profiles', :action => 'edit'
  
  map.activate '/activate/:activation_code',
                :controller => 'accounts',
                :action => 'activate',
                :activation_code => nil
  
end
