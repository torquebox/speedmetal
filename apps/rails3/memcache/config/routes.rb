Memcache::Application.routes.draw do
  resources :keys, :only => [:index, :show, :update, :destroy], :path => ''
end
