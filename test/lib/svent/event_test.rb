require 'test_helper'

describe Svent::Event do

  before do
    @event = Svent::Event.new(:test_event, :test)
  end

  describe "#name" do
    it "returns the name of event" do
      @event.name.must_equal :test_event
    end
  end

  describe "#type" do
    it "returns the type of event" do
      @event.type.must_equal :test
    end
  end

  it "create/read/update/length/delete" do
    # create
    @event.push(proc { p 233 })
    @event.instance_variable_get(:@list).length.must_equal 1, '#create!'

    # read
    callback = @event.instance_variable_get(:@list)[0]
    @event[0].must_equal callback, '#read!'

    # update
    callback = Proc.new {}
    @event[0] = callback
    @event[0].must_equal callback, '#update!'

    # length
    @event.length.must_equal 1, 'length!'

    # delete
    @event.delete(callback)
    @event.length.must_equal 0, 'delete!'
  end

end
