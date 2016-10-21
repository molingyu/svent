# encoding:utf-8
require 'forwardable'

module Svent

  class Event
    extend Forwardable
    def_delegators :@list, :delete, :each, :push, :length, :[]=, :[]

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
