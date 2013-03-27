require "erb"

module Rendering
  def render(action)
    response.write render_to_string(action)
  end

  def render_to_string(action)
    path = template_path(action)
    ERB.new(File.read(path)).result(binding)
  end

  def template_path(action)
    "app/views/#{controller_name}/#{action}.html.erb"
  end

  def controller_name
    self.class.name.gsub(/Controller$/, '').underscore # home
  end
end