Rails.application.routes.draw do
  namespace :admin do
    resources :faq_answers
  end

  get 'sso/authenticate'

  # See how all your routes lay out with "rake routes".

  root                     to: 'communities#index'
  get 'new'                 => 'special_pages#new_to_cornerstone'
  get 'times-and-locations' => 'special_pages#times_and_locations'
  get 'invest-in-community' => 'special_pages#invest_in_cornerstone'

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

  devise_for :users, :skip => [:sessions], :controllers => { invitations: 'devise_override/invitations', registrations:'devise_override/registrations' }
  as :user do
    # get     'join'    => 'devise_override/registrations#new', :as => :new_registrations
    get     'invite'  => 'devise_override/invitations#new',  :as => :new_invitation
    get     'login'   => 'devise/sessions#new',           :as => :new_user_session
    post    'login'   => 'devise/sessions#create',        :as => :user_session
    delete  'logout'  => 'devise/sessions#destroy',       :as => :destroy_user_session
    get     'logout'  => 'devise/sessions#destroy' #convenience
  end

  get 'admin' => 'admin/posts#index'
  namespace :admin do
    resources :ministries, except: :show
    resources :posts do
      collection do
        get 'link_preview'
        delete 'video_complete_upload'
      end
    end

    resources :comm_arts_requests, only: [:index, :create] do
      member do
        get 'toggle_archive'
      end
    end

    resources :uploaded_files, only: [:index, :create, :destroy]
    patch 'uploaded_files' => 'uploaded_files#create'

    resources :approval_requests, only: [:show, :update] do
      member do
        get 'update_status_from_link'
      end
    end

    resources :studies, :lessons

    namespace :content do
      resources :pages
    end

  end

  namespace :api do
    get 'groups'
    get 'current_lesson'
    get 'group'
    post 'login'
    get 'login_and_visit'
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
