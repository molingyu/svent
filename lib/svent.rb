module Svent

  DEBUG = false

end

require_relative "svent/version"
require_relative 'svent/event_manger'

module Svent

  def self.run(event_manger = EventManger.new, &block)
    $log = open('debug.log', 'w') if DEBUG
    @stop = false
    @event_manger = event_manger
    block[@event_manger] if block
    @event_manger.update until @stop
  end

  def self.stop
    @event_manger.on(:event_manger_stop?) do |em|
      em.ok?{ @event_manger.stop? }
      @stop = true
    end
    @event_manger.stop
  end

  def self.kill
    @stop = true
  end

end
