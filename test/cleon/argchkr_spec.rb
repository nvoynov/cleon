require_relative "../spec_helper"
include Cleon::ArgChkr

describe Policy do

  describe '#new' do
    it 'must require three parameters'
  end

  describe '#chk!' do
    it 'must return argument value for valid arguments'
    it 'must raise ArgumentError for invalid arguments'
  end

end
