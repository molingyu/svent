# encoding:utf-8

module Svent

  class Event < Array

    attr_reader :name
    attr_reader :type

    def initialize(name, type)
      super()
      @name = name
      @type = type
    end

  end

end
