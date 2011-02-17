class FibonacciController < ApplicationController
  def index
    num = params[:num].to_i || 100
    @fib = fib(num)
  end

  protected
  def fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end

end
