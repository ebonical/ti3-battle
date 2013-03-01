Fresh::Application.routes.draw do

  resources :games, :only => [:index, :show, :create]
  resources :players, :only => [:update]
  match 'g/:id' => 'games#show'
  match 'readme' => 'games#readme'
  root :to => 'games#index'

end
