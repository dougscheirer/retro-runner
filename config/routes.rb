Rails.application.routes.draw do

  get 'sessions/new'

  resources :projects, shallow: true do
    resources :retros do
      resources :outstandings
      resources :issues do
        resources :votes
      end
    end
  end

  resources :users

  root   'projects#index'

  get    'signup'  => 'users#new'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get    'admin_access_required' => 'page#admin_access_required'
  get    'owner_access_required' => 'page#owner_access_required'

  # custom route for moving the retro from one step to the next
  post   'retros/:id/status/:status' => 'retros#transition_status', as: :transition_retro_status
  post 'issues/:issue_id/votes' => 'votes#create', as: :make_new_vote

  get 'users/:retro_id/votes', :to => 'votes#clear_all', as: :clear_user_votes
  post 'retros/:retro_id/discussed', :to => 'retros#increment_discussed', as: :increment_discussed
end
