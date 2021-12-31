require_relative "../spec_helper"
include Cleon

describe Decor do

  let(:root) { 'Unit' }
  let(:decor) {
    Decor.new(Model.new(%w(model property1 property2 property3)), root)
  }

  describe '#root' do
    it 'must respond to :root' do
      assert_equal root, decor.root
    end
  end

  describe '#const' do
    let(:other1) { Decor.new(Model.new(['other_Model'])) }
    let(:other2) { Decor.new(Model.new(['other model'])) }
    it 'must return const' do
      assert_equal 'Model', decor.const
      assert_equal 'OtherModel', other1.const
      assert_equal 'OtherModel', other2.const
    end
  end

  describe '#arguments' do
    it 'must return coma separated params' do
      assert_equal 'property1, property2, property3', decor.arguments
    end
  end

  describe '#at_arguments' do
    it 'must return coma separated params with "at"' do
      assert_equal '@property1, @property2, @property3', decor.at_arguments
    end
  end

  describe '#keyword_arguments' do
    it 'must return coma separated keyword arguments' do
      assert_equal 'property1:, property2:, property3:', decor.keyword_arguments
    end
  end

  describe '#attributes' do
    let(:attributes) {
      <<~EOF
        attr_reader :property1
        attr_reader :property2
        attr_reader :property3
      EOF
    }
    it 'must return attr_readers' do
      assert_equal attributes, decor.attributes
    end
  end

end
