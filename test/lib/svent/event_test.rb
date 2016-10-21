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
    0..5.times{ @event.push Proc.new {} }
    @event.instance_variable_get(:@list).length.must_equal 5, '#create!'

    # read
    callback = @event.instance_variable_get(:@list)[1]
    @event[1].must_equal callback, '#read!'

    # update
    callback = Proc.new {}
    @event[1] = callback
    @event[1].must_equal callback, '#update!'

    # length
    @event.length.must_equal 5, 'length!'

    # delete
    callback = @event[1]
    @event.delete(callback)
    @event.length.must_equal 4, 'delete!'
  end

end
