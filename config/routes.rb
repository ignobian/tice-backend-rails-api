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

    resources :users, only: [] do
      collection do
        get 'edit', to: 'users#edit'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
