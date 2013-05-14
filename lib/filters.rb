module Filters
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def before_filter(method)
      around_filter do |controller, action|
        controller.send method
        action.call
      end
    end

    def after_filter(method)
      around_filter do |controller, action|
        action.call
        controller.send method
      end
    end

    def around_filters
      @around_filters ||= []
    end

    def around_filter(method=nil, &block)
      if block
        around_filters << block
      else
        around_filters << proc { |controller, action| controller.send method, &action }
      end
    end
  end

  def process(action)
    # around_filter :one
    # around_filter :two
    
    # def one
    #   yield
    # end
    # def two
    #   yield
    # end

    # one do
    #   two do
    #     super
    #   end
    # end

    action_proc = proc { super }
    self.class.around_filters.reverse.each do |filter|
      current_action = action_proc
      action_proc = proc { filter.call(self, current_action) }
    end

    action_proc.call
  end
end
