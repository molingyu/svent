require 'test_helper'
require 'svent/version'

describe 'Svent version' do
  it 'is defined' do
    Svent::VERSION.wont_be_nil
  end
end