Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    get 'wake-up', to: 'pages#wake_up'
    get 'list-for-xml', to: 'pages#list_for_xml'
    get 'index-xml', to: 'pages#index_xml'
    get 'main-xml', to: 'pages#main_xml'
    get 'get-category-xml/:slug', to: 'pages#get_category_xml'

    post 'google-login', to: 'registrations#google_login'
    post 'facebook-login', to: 'registrations#facebook_login'

    put 'forgot-password', to: 'registrations#forgot_password'
    put 'reset-password', to: 'registrations#reset_password'

    resources :sessions, only: [:create]
    resources :registrations, only: [:index, :show, :create, :update, :destroy] do
      collection do
        post 'pre-signup', to: 'registrations#pre_signup'
        put 'forgot-password', to: 'registrations#forgot_password'
        put 'reset-password', to: 'registrations#reset_password'
        delete 'delete-profile', to: 'registrations#delete_profile'
      end
    end

    resources :users, only: [:index] do
      collection do
        get 'stats', to: 'users#stats'
        post 'contact-blog-author', to: 'users#email_author'
        get 'followers', to: 'users#followers'
        post 'toggle-follower', to: 'users#toggle_follower'
        get 'edit', to: 'users#edit'
        get ':username', to: 'users#show'
        put 'update', to: 'users#update'
      end
    end

    resources :categories, only: [:index, :create] do
      collection do
        get ':slug', to: 'categories#show'
        delete ':slug', to: 'categories#destroy'
      end
    end

    resources :tags, only: [] do
      collection do
        get 'featured', to: 'tags#featured'
        get ':slug', to: 'tags#show'
      end
    end

    resources :blogs, only: [:index, :create] do
      resources :comments, only: [:create]
      member do
        get 'list-related', to: 'blogs#list_related'
      end
      collection do
        get 'feed', to: 'blogs#feed'
        get 'search', to: 'blogs#search'
        post 'with-categories-tags', to: 'blogs#with_category_tag'
        post 'advanced-search', to: 'blogs#advanced_search'
        delete ':slug', to: 'blogs#destroy'
        get 'from-self', to: 'blogs#from_user'
        put ':slug', to: 'blogs#update'
        get ':slug', to: 'blogs#show'
        get ':slug/comments', to: 'comments#from_blog'
        put ':slug/add-clap', to: 'blogs#add_clap'
      end
    end

    resources :shares, only: [:create] do
      collection do
        post 'not-signed-in', to: 'shares#add_not_signed_in'
      end
    end

    resources :impressions, only: [:create] do
      collection do
        post 'not-signed-in', to: 'impressions#add_not_signed_in'
      end
    end

    resources :reports, only: [:index, :create, :destroy]

    resources :conversations, only: [:index, :show] do
      resources :messages, only: [:create]

      collection do
        get 'find'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
