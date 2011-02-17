Fibonacci::Application.routes.draw do
  match ':num' => 'fibonacci#index'
  root :to => "fibonacci#index"
end
