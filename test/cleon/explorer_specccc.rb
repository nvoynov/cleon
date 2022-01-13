require_relative '../spec_helper'

describe Explorer do
  describe 'unknown cleon source' do
    it 'must raise Cleon::Error' do
      err = assert_raises(Cleon::Error) { Explorer.('bla-bla-bla') }
      assert_match %r{cannot load such file -- bla-bla-bla}, err.message
    end
  end

  describe 'call' do

    it 'must return services' do
      Explorer.('users').each do |deco|
        # puts "\n--- #{deco.name}"
        puts deco.lib_helper_method
        puts "\n"
        # puts deco.api_helper_method
      end
    end
  end
end
