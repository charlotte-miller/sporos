Rails.application.routes.draw do
  # See how all your routes lay out with "rake routes".

  root                     to: 'communities#index'
  get 'new'                 => 'special_pages#new_to_cornerstone'
  get 'times-and-locations' => 'special_pages#times_and_locations'
  get 'invest'              => 'special_pages#invest_in_cornerstone' 

  # Search
  get  'search' => 'search#index'
  get  'search/preload'     => 'search#preload'
  post 'search/conversion'  => 'search#conversion'
  post 'search/abandonment' => 'search#abandonment'
  
  resources :media do
  end
  
  resources :pages, only:[:show]
  resources :posts, only:[:index, :show]
  
  # Library
  resources :studies, only: [:index, :show ], path: 'library' do
    resources :lessons, only: [:index, :show ] do
      resources :questions, only: [:index, :show, :new, :create], shallow: true do
        post :block, :star, :on => :member
        resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true do
          post :block, :star, :on => :member
        end
      end
    end
  end
  
  # Ministry
  get '/:id'  => 'communities#show', constraints: {id: /men|women|rendezvous|teens|kids|outreach/}
  
  # # Questions
  # resources :questions do
  #   resources :answers
  # end

  # Groups
  resources :groups do
    resources :meetings do
      resources :questions, only: [:index, :new, :create]
      # NOTE: :block, :star, :show, :answers 
      # already part of the previous shallow routes
    end
  end
  
  devise_for :users, :skip => [:sessions]
  as :user do
    get     'join'  => 'devise/registrations#new', :as => :new_registrations
    get     'login' => 'devise/sessions#new',      :as => :new_user_session
    post    'login' => 'devise/sessions#create',   :as => :user_session
    delete  'logout'=> 'devise/sessions#destroy', :as => :destroy_user_session
    get     'logout'=> 'devise/sessions#destroy' #convenience
  end

  namespace :admin do
    resources :ministries
    resources :posts do
      collection do |variable|
        get 'link_preview'
      end
    end
    
    resources :studies, :lessons
    
    namespace :content do
      resources :pages
    end
    
  end
  
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


  require 'mixins/http_authentication'
  mount RESQUE_DASHBOARD, at: "/queue"
end
