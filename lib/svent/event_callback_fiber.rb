# encoding:utf-8

module Svent

  class EventCallbackFiber
    # Wrap the event callback function with Fiber.

    attr_reader :name
    attr_reader :info
    attr_reader :callback

    def initialize(helper, name, callback, info)
      @name = name
      @info = info
      @callback = callback
      @fiber = Fiber.new do
        @callback.call(helper, info)
        @fiber = nil
      end
      # self.resume
      @return = nil
    end

    def resume
      if @return
        @fiber = nil
      else
        @return = @fiber.resume
      end
    end

    def alive?
      @fiber != nil
    end

  end

end