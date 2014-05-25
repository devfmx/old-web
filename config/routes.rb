Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations" }
  devise_scope :user do
    get 'users/logout' => 'devise/sessions#destroy'
  end

  root 'public#index'

  resources :applications do
  end

end
