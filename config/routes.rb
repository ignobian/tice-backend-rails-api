Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    get 'wake-up', to: 'pages#wake_up'

    resources :sessions, only: [:create]
    resources :registrations, only: [:index, :show, :create, :update, :destroy] do
      collection do
        post 'pre-signup', to: 'registrations#pre_signup'
        post 'invite', to: 'registrations#invite'
        post 'signup-from-invite', to: 'registrations#create_on_invite'
        put 'forgot-password', to: 'registrations#forgot_password'
        put 'reset-password', to: 'registrations#reset_password'
      end
    end

    resources :users, only: [:index] do
      collection do
        get 'edit', to: 'users#edit'
        put 'update', to: 'users#update'
      end
    end

    resources :categories, only: [:index, :create] do
      collection do
        get ':slug', to: 'categories#show'
        delete ':slug', to: 'categories#destroy'
      end
    end

    resources :blogs, only: [:create] do
      member do
        get 'list-related', to: 'blogs#list_related'
      end
      collection do
        put ':slug', to: 'blogs#update'
        get ':slug', to: 'blogs#show'
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
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
