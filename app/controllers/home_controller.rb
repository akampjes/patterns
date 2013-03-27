class HomeController < ApplicationController
  def index
    response.write "Hello from home controller"
  end
end