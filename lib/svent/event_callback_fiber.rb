# encoding:utf-8

module Svent

  class EventCallbackFiber

    attr_reader :name
    attr_reader :info
    attr_reader :callback

    def initialize(event_manger, name, callback, info)
      @event_manger = event_manger
      @name = name
      @info = info
      @callback = callback
      @fiber = Fiber.new do
        @callback.call(event_manger, info)
        @fiber = nil
      end
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