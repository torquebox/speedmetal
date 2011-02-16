class HelloController < ApplicationController
  def index
    @name = params[:name]
  end

end
