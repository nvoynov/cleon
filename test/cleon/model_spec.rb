require_relative "../spec_helper"

describe Model do

  let(:plain) { Model.new(%w(model prop1 prop2 prop3)) }
  let(:guard) { Model.new(%w(model prop1 prop2:str prop3:int)) }

  describe '#new plain model' do
    it 'must provide :name and :params' do
      assert_equal 'model', plain.name
      assert_equal 'prop1', plain.params[0].name
      assert_equal 'prop2', plain.params[1].name
      assert_equal 'prop3', plain.params[2].name
      plain.params.each{|pa| refute pa.guard}
    end
  end

  describe '#new guard model' do
    it 'must provide :name and :params' do
      assert_equal 'model', guard.name
      assert_equal 'prop1', guard.params[0].name
      refute guard.params[0].guard
      assert_equal 'prop2', guard.params[1].name
      assert_equal 'str', guard.params[1].guard
      assert_equal 'prop3', guard.params[2].name
      assert_equal 'int', guard.params[2].guard
    end
  end

end
