HelloWorld::Application.routes.draw do
  match ':name' => 'hello#index'
  root :to => "hello#index"
end
