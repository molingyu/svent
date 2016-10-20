# encoding:utf-8

module Svent

  class EventManger

    attr_reader :events
    attr_reader :this
    attr_reader :timers
    attr_reader :counters
    attr_reader :timer_filters
    attr_reader :counter_filters

    def initialize
      @events = {}
      @this = nil
      @event_callback_fibers = []
      @timers = {}
      @counters = {}
      @timer_filters = {}
      @counter_filters = {}
    end

    def update
      if @event_callback_fibers != []
        @event_callback_fibers.each do |obj|
          next @event_callback_fibers.delete(obj) unless obj.alive?
          @this = obj
          obj.resume
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
      event = @events[name]
      event.each{ |callback| @event_callback_fibers.push(EventCallbackFiber.new(self, name, callback, info)) } if event
    end

    def on(name, type = nil, index = nil, &callback)
      name = name.to_sym if name.class == String
      if name == :event_manger_stop?
        raise 'error:The event(:event_manger_stop?) can only have one callback.' if @events.include?(:event_manger_stop?)
      end
      event = @events[name] ||= Event.new(name, type)
      index = event.length unless index
      event[index] = callback
    end

    def stop
      trigger(:event_manger_stop)
      trigger(:event_manger_stop?)
    end

    def stop?
      @event_callback_fibers.size == 1 && @event_callback_fibers.last.name == :event_manger_stop?
    end

    def delete
      @events[@this.name].delete(@this.callback)
    end

    def delete_after
      delete
      Fiber.yield true
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
      timer = @timers[@this.object_id]
      timer = Time.now unless timer
      loop do
        break @timers.delete(@this.object_id) unless Time.now - timer < value
        Fiber.yield
      end
    end

    def times(value)
      counter = @counters[@this.object_id]
      counter ? counter += 1 : counter = 1
      loop do
        break @counters.delete(@this.object_id) if counter > value
        Fiber.yield
      end
    end

    def wait_filter(value)
      timer_filter = @timer_filters[@this.object_id]
      return timer_filter = Time.now unless timer_filter
      loop do
        break @timer_filters.delete(@this.object_id) unless Time.now - timer_filter < value
        Fiber.yield true
      end
    end

    def times_filter(value)
      object_id =
      counter_filter = @counter_filters[@this.object_id]
      counter_filter ? counter_filter += 1 : (return counter_filter = 1)
      loop do
        break @counter_filters.delete(@this.object_id) if @counter_filters[object_id] > value
        Fiber.yield true
      end
    end

  end

end