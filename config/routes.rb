require 'sidekiq/web'

# TODO路由测试

Rails.application.routes.draw do

  # devise_for :users, controllers: {
  #   sessions: 'users/sessions',
  #   omniauth_callbacks: 'users/omniauth_callbacks'
  # }

  root 'welcome#index', defaults: { format: :html }

  namespace :admin do
    authenticate :user, lambda { |u| Ability.new(u, 'Admin').can? :manage, :sidekiq } do
      mount Sidekiq::Web => '/sidekiq'
    end

    root to: redirect('/admin/dashboard')
    resources :dashboard
  end

  %w(404 500).each do |code|
    match code, to: "errors#render_#{code}", via: [:get, :post, :put, :delete]
  end
end
