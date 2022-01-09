require_relative "../spec_helper"

describe Param do

  let(:plain) { 'para' }
  let(:guard) { 'para:guarded' }
  let(:plain_param) { Param.new(plain) }
  let(:guard_param) { Param.new(guard) }

  describe '#new' do
    it 'must provide :name and :guard' do
      assert plain_param.name
      refute plain_param.guard
      assert guard_param.name
      assert guard_param.guard
    end
  end

end
