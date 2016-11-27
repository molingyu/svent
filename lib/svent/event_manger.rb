# encoding:utf-8
require_relative 'event'
require_relative 'event_callback_fiber'

module Svent

  class EventManger

    module Helper
      class << self

        attr_writer :this

        def init(events, callback_fibers)
          @this = nil
          @events = events
          @callback_fibers = callback_fibers
          @timers = {}
          @counters = {}
          @timer_filters = {}
          @counter_filters = {}
        end

        def after_delete
          @events[@this.name].delete(@this.callback)
        end

        def delete
          after_delete
          Fiber.yield true
        end

        def ok?(info = nil, &block)
          Kernel.loop do
            break if block.call(info)
            Fiber.yield
          end
        end

        def loop(condition, info = nil, &block)
          Kernel.loop do
            break if condition.call
            block.call(info)
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
          counter ? @counters[@this.object_id] += 1 : @counters[@this.object_id] = 1
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
          counter_filter = @counter_filters[@this.object_id]
          counter_filter ? @counter_filters[@this.object_id] += 1 : (return @counter_filters[@this.object_id] = 1)
          loop do
            break @counter_filters.delete(@this.object_id) if @counter_filters[object_id] > value
            Fiber.yield true
          end
        end

      end
    end

    attr_reader :events

    def initialize
      @events = {}
      @event_callback_fibers = []
      @next_callback_fibers = []
      Helper.init(@events, @event_callback_fibers)
    end

    def stop
      trigger(:event_manger_stop)
      trigger(:event_manger_stop?)
    end

    def stop?
      @next_callback_fibers == [] && @event_callback_fibers == []
    end

    if Svent::DEBUG
      def debug_arr
        arr = []
        next_arr = []
        @event_callback_fibers.each{|o| arr.push [o.name, o.object_id] }
        @next_callback_fibers.each{|o| next_arr.push [o.name, o.object_id] }
        {callback: arr, next: next_arr}
      end

      def logger(*arg)
        str = ''
        arg.each{ |s| str += "#{s}, " }
        $log.write "#{str[0, str.size - 2]}\n"
      end
    end

    def update
      logger '='*4+'update' if Svent::DEBUG
      if @event_callback_fibers != []
        @next_callback_fibers = []
        loop do
          obj = @event_callback_fibers.pop
          break unless obj
          logger "==fiber-#{obj.name}(#{obj.object_id}) call:" if Svent::DEBUG
          logger'before:', debug_arr, @event_callback_fibers.size if Svent::DEBUG
          Helper.this = obj
          obj.resume
          Helper.this = nil
          logger'after:', debug_arr, @event_callback_fibers.size if Svent::DEBUG
          @next_callback_fibers.push obj if obj.alive?
        end
        @event_callback_fibers = @next_callback_fibers
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
      event.each{ |callback| @event_callback_fibers.push(EventCallbackFiber.new(Helper, name, callback, info)) } if event
      logger 'trigger:', name, debug_arr, @event_callback_fibers.size if Svent::DEBUG
    end

    def on(name, info = nil, index = nil, &callback)
      name = name.to_sym if name.class == String
      if name == :event_manger_stop?
        raise 'error:The event(:event_manger_stop?) can only have one callback.' if @events.include?(:event_manger_stop?)
      end
      event = @events[name] ||= Event.new(name, info)
      index = event.length unless index
      event[index] = callback
    end

    def event(name, info)
      @events[name] ? @events[name].info = info : Event.new(name, info)
    end

    def event_info(name, key, value)
      event = @events[name] ||= Event.new(name, info)
      event.info[key] = value
    end

    def have(name)
      @events.each { |event| return true if event.name == name }
      false
    end

  end

end