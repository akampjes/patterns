require "active_support/concern"
require "active_support/callbacks"

module Filters
  extend ActiveSupport::Concern
  include ActiveSupport::Callbacks

  included do
    define_callbacks :process
  end

  module ClassMethods
    def before_filter(method)
      set_callback :process, :before, method
    end

    def after_filter(method)
      set_callback :process, :after, method
    end

    def around_filter(method=nil, &block)
      set_callback :process, :around, method, &block
    end
  end

  def process(action)
    run_callbacks :process do
      super
    end
  end
end
