require 'test_helper'

describe 'Svent version' do
  it 'is defined' do
    Svent::VERSION.wont_be_nil
  end
end