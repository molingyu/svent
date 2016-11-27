# encoding:utf-8
require 'forwardable'

module Svent

  class Event
    extend Forwardable
    def_delegators :@list, :delete, :each, :push, :length, :[]=, :[]

    attr_reader :name
    attr_reader :info

    def initialize(name, info)
      @list = []
      @name = name
      @info = info
    end

    def reverse
      event = Event.new(@name, @info)
      event.instance_variable_set(:@list, @list.reverse)
      event
    end

  end

end
