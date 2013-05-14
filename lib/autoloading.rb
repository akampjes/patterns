require "core_ext"

$LOAD_PATH.unshift "app/controllers", "app/models", "config"

class Object
  def self.const_missing(name)
    # p name
    # super
    file_name = name.to_s.underscore # :HomeController => home_controller
    require file_name
    const_get name # :HomeController => HomeController
  end
end