# encoding:utf-8

module Svent

  class EventManger

    attr_accessor :events
    attr_accessor :this
    attr_accessor :timer
    attr_accessor :counter
    attr_accessor :timer_filter
    attr_accessor :counter_filter

    def initialize
      @events = {}
      @event_callback_fibers = []
      @timer = {}
      @counter = {}
      @timer_filter = {}
      @counter_filter = {}
    end

    def update
      if @event_callback_fibers != []
        @event_callback_fibers.each do |o|
          next @event_callback_fibers.delete(o) unless o.alive?
          @this = o
          o.resume
          @this = nil
        end
      end
    end

    def trigger(name, info = nil)
      if info
        def info.method_missing(sym)
          self[sym] if self.key?(sym)
        end
      end
      name = name.to_sym if name.class == String
      if @events[name]
        @events[name].each do |callback|
          @event_callback_fibers.push(EventCallbackFiber.new(self, name, callback, info))
        end
      end
    end

    def on(name, type = nil, index = nil, &callback)
      name = name.to_sym if name.class == String
      if name == :event_manger_stop?
        raise 'error:The event(:event_manger_stop?) can only have one callback.' if @events.include?(:event_manger_stop?)
      end
      @events[name] = @events[name] || Event.new(name, type)
      index = @events[name].length unless index
      @events[name][index] = callback
    end

    def stop
      trigger(:event_manger_stop)
      trigger(:event_manger_stop?)
    end

    def stop?
      @event_callback_fibers.size == 1 && @event_callback_fibers.last.name == :event_manger_stop?
    end

    def delete(after = false)
      @events[@this.name].delete(@this.callback)
      Fiber.yield true unless after
    end

    def ok?(&block)
      loop do
        break if block.call
        Fiber.yield
      end
    end

    def filter(&block)
      Fiber.yield true unless block.call
    end

    def wait(value)
      @timer[@this.object_id] = Time.now unless @timer[@this.object_id]
      loop do
        break @timer.delete(@this.object_id) unless Time.now - @timer[@this.object_id] < value
        Fiber.yield
      end
    end

    def times(value)
      @counter[@this.object_id] = 1 unless @counter[@this.object_id]
      @counter[@this.object_id] += 1
      loop do
        break @counter.delete(@this.object_id) if @counter[@this.object_id] > value
        Fiber.yield
      end
    end

    def wait_filter(value)
      return @timer_filter[@this.object_id] = Time.now unless @timer_filter[@this.object_id]
      loop do
        break @timer_filter.delete(@this.object_id) unless Time.now - @timer_filter[@this.object_id] < value
        Fiber.yield true
      end
    end

    def times_filter(value)
      return @counter_filter[@this.object_id] = 1 unless @counter_filter[@this.object_id]
      @counter_filter[@this.object_id] += 1
      loop do
        break @counter_filter.delete(@this.object_id) if @counter_filter[@this.object_id] > value
        Fiber.yield true
      end
    end

  end

end