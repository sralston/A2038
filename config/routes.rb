A2038::Application.routes.draw do
	get "login/waiting" #change the logins to match??
	get "login/logged_in"
	get "login/update"
	get	"game/start"
	get "game/init"
	post "game/buy"
	post "game/pass"
	post "game/bid"
	post "game/bw"
	get "game/update"
	get "game/bought_flag"
	get "game/bid_flag"
	get "game/bidwar_flag"
	get "game/buy_flag"
	get "login/testing"
	
	resources	:sessions, :only => [:create, :destroy]
	
	match 	'/signup',	:to => 'customers#new'
	match	'/signin',	:to => 'sessions#new'
	match	'/signout',	:to => 'sessions#destroy'
	match	'/game/operating_round', :to => 'game#operating_round'
	
	resources	:customers
	resources	:players
	resources	:games
	resources	:events
	resources	:shares

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "login#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
