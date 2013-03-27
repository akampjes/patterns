Routes = Router.new do
  match '/' => 'home#index'
  match '/hi' => 'home#index'
  match '/home/index' => 'home#index'
  match '/echo' => 'echo#index'
  match '/users' => 'users#index'
end