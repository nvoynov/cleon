require_relative "../spec_helper"
include Cleon

describe MetaGem do

  let(:path) { Dir.pwd }
  let(:meta) { MetaGem.new(path) }

  it 'must provide something' do
    assert meta.gem?
    assert_equal 'cleon', meta.base
    assert_equal 'cleon.rb', meta.source
    assert_equal "Cleon", meta.const
    assert_equal "#{path}/lib", meta.lib

    refute MetaGem.new(File.join(Dir.pwd, 'lib')).gem?
  end

  describe 'complex name' do
    let(:path) { 'complex_name-api' }

    it 'must use part until -' do
      SpecGem.(path) do
        dir = Dir.pwd
        meta = MetaGem.new()
        assert_equal 'complex_name', meta.base
        assert_equal 'ComplexName', meta.const
        assert_equal "complex_name.rb", meta.source
        assert_equal "#{dir}/lib", meta.lib
        assert_equal "#{dir}/lib/complex_name", meta.base_dir
      end
    end
  end

end
