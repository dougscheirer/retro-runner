Rails.application.routes.draw do

  get 'sessions/new'

  resources :projects, shallow: true do
    resources :retros do
      resources :issues
      resources :actions
      resources :votes
    end
  end

  resources :users

  root   'projects#index'

  get    'signup'  => 'users#new'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get    'admin_access_required' => 'page#admin_access_required'
end
