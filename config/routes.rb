Rails.application.routes.draw do
  get 'users/new'

  get 'welcome/index'

  root 'welcome#index'

  get 'statistic/actual' => 'statistic#actual'
  get 'statistic/history' => 'statistic#history'
  get 'statistic/weekday' => 'statistic#weekday'
  get 'statistic/minMax' => 'statistic#minMax'
  get 'statistic/reference' => 'statistic#reference'


  get 'statistic/getCityDataById/:cityId' => 'statistic#getCityDataById'
  get 'statistic/getCityDataByIdSortedByWeekday/:cityId' => 'statistic#getCityDataByIdSortedByWeekday'

  get 'route/:origin/:destination' => 'routes#get_json'

  resources :users, only: [:create,:new,:index]
  get 'login', to: 'users#login'
  post 'login', to: 'users#authenticate'
  get 'logout', to: 'users#logout'

end
