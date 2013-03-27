class Router
  def initialize(&block)
    @routes = {}
    instance_eval(&block)
  end

  def match(options)
    # {"/path" => 'home#index'}
    options.each_pair do |path, route|
      @routes[path] = route.split('#') # 'home#index' => ['home', 'index']
    end
  end

  def recognize(path)
    @routes[path]
  end
end