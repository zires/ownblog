ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'login'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resources :pics, :member =>{:thumb => :get, :avatar => :get,:bigger => :get}, :collection =>{:picategory => :get} 
  map.resource :session,:member => {:login => :get}
  map.resource :shares
  map.resources :articles, :has_many => :comments, :member => {:feed => :get}
  map.resources :categories do |category|
    category.resources :pics
  end
  map.picategory '/pics/category/:category_id',:controller => "pics",:action =>"picategory"
  map.about '/about',:controller =>'blog',:action => 'about'
  map.video '/video',:controller =>'blog',:action => 'video'
  map.share '/share',:controller =>'blog',:action => 'share'
  map.root :controller => 'blog',:action => 'index'
  # default route
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
