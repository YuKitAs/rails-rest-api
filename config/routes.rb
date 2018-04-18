Rails.application.routes.draw do
  resources :posts do
    resources :comments
  end

  post "register" => "users#register"
  post "login" => "authentication#login"
end
