class KeysController < ApplicationController
  def index
  end

  def show
    @key = params[:id]
    @value = Rails.cache.read(@key)
    render :json => { @key => @value }
  end

  def update
    @key = params[:id]
    @value = request.raw_post
    Rails.cache.write(@key, @value)
    render :json => { @key => @value }
  end

  def destroy
    @key = params[:id]
    Rails.cache.delete(@key)
    render :json => { @key => @value }
  end
end
