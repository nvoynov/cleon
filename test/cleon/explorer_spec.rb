require_relative '../spec_helper'

describe Explorer do
  describe 'unknown cleon source' do
    it 'must raise Cleon::Error' do
      err = assert_raises(Cleon::Error) { Explorer.('bla-bla-bla') }
      assert_match %r{cannot load such file -- bla-bla-bla}, err.message
    end
  end

  describe 'call' do
    # TODO: create a Cleon's gem, generate few services, install 
    it 'must return services' do
      pp Explorer.('users')
    end
  end
end
