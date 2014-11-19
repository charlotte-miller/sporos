Rails.application.routes.draw do
  # See how all your routes lay out with "rake routes".

  root                         'special_pages#homepage'
  get 'new'                 => 'special_pages#new_to_cornerstone'
  get 'times-and-locations' => 'special_pages#times_and_locations'
  get 'invest'              => 'special_pages#invest_in_cornerstone' 

  resources :media do
  end
  
  
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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


  devise_for :users, :skip => [:sessions]
  as :user do
    get     'join' => 'devise/registrations#new', :as => :new_registrations
    get     'login' => 'devise/sessions#new',      :as => :new_user_session
    post    'login' => 'devise/sessions#create',   :as => :user_session
    delete  'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get     'logout'  => 'devise/sessions#destroy' #convenience
  end

  namespace :admin do
    # Directs /admin/products/* to Admin::PostsController
    # (app/controllers/admin/posts_controller.rb)
    # resources :posts
  end
  
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails) && Rails.env.development?
end
