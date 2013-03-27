require File.dirname(__FILE__) + '/test_helper'

class RenderingTest < Test::Unit::TestCase
  def setup
    @controller = HomeController.new
  end

  def test_controller_name
    assert_equal "home", @controller.controller_name
  end

  def test_template_path
    assert_equal "app/views/home/index.html.erb", @controller.template_path("index")
  end

  def test_render_to_string
    assert_not_nil @controller.render_to_string("index")
  end
end