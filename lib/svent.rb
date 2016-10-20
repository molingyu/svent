require "svent/version"
require 'svent/event'
require 'svent/event_callback_fiber'
require 'svent/event_manger'

module Svent

  def self.run(event_manger = EventManger.new, &block)
    yield  event_manger
    block.call
    loop{ event_manger.update }
  end

end
