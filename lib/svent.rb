require_relative "svent/version"
require_relative 'svent/event'
require_relative 'svent/event_callback_fiber'
require_relative 'svent/event_manger'

module Svent

  def self.run(event_manger = EventManger.new, &block)
    block.call(event_manger) if block
    loop{ event_manger.update }
  end

end
