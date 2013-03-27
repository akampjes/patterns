module Filters
  def self.included(base)
    # base == ActionController::Base
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

    # around_filter :layout
    # def layout
    #   response.write "<html>"
    #   yield
    #   response.write "</html>"
    # end
    # around_filter { |controller, action| action.call }
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
    # 
    # proc do |controller, action|
    #   # run around one logic
    #   action.call
    # end.call(controller, action1)
    # action1 = proc do |controller, action|
    #   # run around two logic
    #   action.call
    # end.call(controller, action2)
    # action2 = proc { super }

    self.class.around_filters.reverse.inject(proc { super }) do |parent_proc, filter|
      proc { filter.call(self, parent_proc) }
    end.call
  end
end
