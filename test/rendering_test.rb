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

  def test_compile_template
    method_name = @controller.compile_template(@controller.template_path("index"))
    assert_equal "app_views_home_index_html_erb", method_name
    assert_respond_to @controller, method_name
    assert_match "<p>", @controller.send(method_name)
  end

  def test_render_with_layout
    assert_match "<head>", @controller.render_to_string("index")
  end
  
  def test_render_with_content_for
    assert_match "<title>Hello</title>", @controller.render_to_string("index")
  end
end