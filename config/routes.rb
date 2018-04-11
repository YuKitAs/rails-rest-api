Rails.application.routes.draw do
  get "posts" => "posts#index"
  get "posts/:id" => "posts#show"
  post "posts" => "posts#create"
  put "posts/:id" => "posts#update"
  delete "posts/:id" => "posts#destroy"

  post "register" => "users#register"
  post "login" => "authentication#login"
end
