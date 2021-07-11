Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks, except: %i[new edit], param: :slug

  root 'home#index'
  get '*path', to: 'home#index', via: :all
end
