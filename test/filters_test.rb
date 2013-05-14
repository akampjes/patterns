require File.dirname(__FILE__) + '/test_helper'
require "app/controllers/application_controller"

class FiltersTestController < ApplicationController
  around_filter :around1
  before_filter :before
  around_filter :around2
  after_filter :after

  def initialize(out)
    @out = out
  end

  def before
    @out << :before
  end
  
  def after
    @out << :after
  end

  def around1
    @out << "around1"
    yield
    @out << "/around1"
  end

  def around2
    @out << "around2"
    yield
    @out << "/around2"
  end

  def index
    @out << :index
  end
end

class FiltersTest < Test::Unit::TestCase
  def test_filters
    out = []
    FiltersTestController.new(out).process(:index)
    
    # assert_equal [:before,
    #               :index], out
    
    # With after_filter
    # assert_equal [:before,
    #               :index,
    #               :after], out

    # With around_filters
    assert_equal ["around1",
                    :before,
                    "around2",
                      :index,
                      :after,
                    "/around2",
                  "/around1"], out
  end
end