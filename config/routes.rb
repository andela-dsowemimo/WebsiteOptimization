Rails.application.routes.draw do
  get 'stats/index'

  get 'comments/new'
  post 'comments/create', as: "comments"

  get 'articles/:format' => 'articles#show'
  root to: 'author#index'
end
