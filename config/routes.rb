Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    get 'wake-up', to: 'pages#wake_up'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
