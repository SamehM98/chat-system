
require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'


Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      resources :applications, param: :token, only: [:create, :show, :update, :index] do
        resources :chats, param: :number, only: [:create, :show, :index] do
          resources :messages, param: :number, only: [:create, :show, :update, :index] do
            get "search", to: "chats#search_messages", on: :collection
          end
        end
      end
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
