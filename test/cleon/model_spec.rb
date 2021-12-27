require_relative "../spec_helper"
include Cleon

describe Model do

  let(:model) { Model.new(%w(model property1 property2 property3)) }

  describe '#new' do
    it 'must provide :name and :params' do
      assert_equal 'model', model.name
      assert_equal 'property1', model.params[0]
      assert_equal 'property2', model.params[1]
      assert_equal 'property3', model.params[2]
    end
  end

end
