Rails.application.routes.draw do
  get 'users/new'

  get 'welcome/index'

  root 'welcome#index'

  get 'statistic/actual' => 'statistic#actual'
  get 'statistic/history' => 'statistic#history'
  get 'statistic/weekday' => 'statistic#weekday'
  get 'statistic/minMax' => 'statistic#minMax'
  get 'statistic/reference' => 'statistic#reference'

  get 'statistic/save' => 'statistic#save'
  get 'statistic/clean' => 'statistic#clean'


  get 'statistic/getCityDataById/:cityId' => 'statistic#get_city_prices_by_id'
  get 'statistic/getCityDataByIdSortedByWeekday/:cityId' => 'statistic#get_city_price_per_weekday_by_id'

  get 'route/:origin/:destination' => 'routes#get_json', format:true
  get 'route/:id' => 'routes#get_route'
  # :constraints => http://stackoverflow.com/questions/5621351/handle-rails-route-with-gps-parameter
  get 'garage/:lat/:lng' => 'garages#get_json', format:true, :constraints => {:lat => /\-*\d+.\d+/ , :lng => /\-*\d+.\d+/ , :range => /\d+/}

  resources :users, only: [:create,:new,:index]
  get 'login', to: 'users#login'
  post 'login', to: 'users#authenticate'
  get 'logout', to: 'users#logout'

  get 'route/add/:id', to: 'users#add_route'
  get 'route/remove/:id', to: 'users#remove_route'
  get 'dashboard', to: 'users#dashboard'

end
