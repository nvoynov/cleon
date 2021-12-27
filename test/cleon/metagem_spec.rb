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

end
