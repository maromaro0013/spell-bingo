Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'room#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  get '/room/index' => 'room#index', as: :room_index
  post '/room/create' => 'room#create', as: :room_create
  get '/room/get_list' => 'room#get_list', as: :room_get_list
  delete '/room/destroy' => 'room#destroy', as: :room_destroy
  get '/room/edit/:id' => 'room#edit', as: :room_edit

  post '/room/edit/:id/create_spell' => 'room#create_spell', as: :room_create_spell
  post '/room/edit/:id/get_spells' => 'room#get_spells', as: :room_get_spells

  post '/spell/edit' => 'spell#edit', as: :spell_edit

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
