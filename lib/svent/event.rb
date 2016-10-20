# encoding:utf-8

module Svent

  class Event

    def_delegator @list, :delete, :each_index, :each, :push

    attr_reader :name
    attr_reader :type

    def initialize(name, type)
      @list = []
      @name = name
      @type = type
    end

    def reverse
      event = Event.new(@name, @type)
      event.instance_variable_set(:@list, @list.reverse)
      event
    end

  end

end
