class HomeController < ApplicationController
  before_filter :header

  def index
    response.write "<p>Hello from home controller</p>"
  end

  def header
    response.write "<h1>My App</h1>"
  end
end