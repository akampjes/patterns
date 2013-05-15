require "erb"

module Rendering
  def render(action)
    response.write render_to_string(action)
  end

  def render_to_string(action)
    path = template_path(action)
    method = compile_template(path)
    # content = send(method)
    content_for :layout, send(method)

    layout_method = compile_template(layout_path)
    # send(layout_method) { content }
    send(layout_method) { |name = :layout| @content_for[name] }
  end

  def compile_template(path)
    method_name = path.gsub(/\W/, '_')

    # Compile the template to a method on first pass
    unless respond_to?(method_name)
      template = ERB.new(File.read(path))
      self.class.class_eval <<-CODE
        def #{method_name}
          #{template.src}
        end
      CODE
    end

    method_name
  end

  def content_for(name, content)
    # In Rails: stored in something called ViewFlow, which is just a Hash by default.
    #           Uses fibers when streaming template rendering.
    @content_for ||= {}
    @content_for[name] = content
  end

  def template_path(action)
    "app/views/#{controller_name}/#{action}.html.erb"
  end

  def layout_path
    "app/views/layouts/application.html.erb"
  end

  def controller_name
    self.class.name.gsub(/Controller$/, '').downcase # home
  end
end