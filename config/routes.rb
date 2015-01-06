Rails.application.routes.draw do
  get 'users/new'

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  get 'statistic/actual' => 'statistic#actual'
  get 'statistic/history' => 'statistic#history'
  get 'statistic/weekday' => 'statistic#weekday'
  get 'statistic/minMax' => 'statistic#minMax'


  get 'statistic/getCityDataById/:cityId' => 'statistic#getCityDataById'
  get 'statistic/getCityDataByIdSortedByWeekday/:cityId' => 'statistic#getCityDataByIdSortedByWeekday'




  get 'route/:origin/:destination' => 'routes#get_json'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

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

  resources :users, only: [:create,:new,:index]
  get 'login', to: 'users#login'
  post 'login', to: 'users#authenticate'
  get 'logout', to: 'users#logout'

end
