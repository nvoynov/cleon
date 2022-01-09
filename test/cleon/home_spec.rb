require_relative '../spec_helper'
include Cleon::Services

module SharedSpec
  extend Minitest::Spec::DSL

  # requred let(:home) variable installed in real test
  it 'must return base' do

  end
end

describe Home do

  let(:home_dir) { 'cleon_clone' }

  describe '#base' do
    it 'must return base' do
      SpecTemp.() do
        _, _ = capture_subprocess_io { CloneCleon.(home_dir) }
        home = Home.new(home_dir)
        assert_equal home_dir.downcase, home.base
        assert_equal "#{home.base}/lib", home.lib
        assert_equal "#{home.base}/lib/#{home.base}", home.base_dir
        assert_equal "#{home.base}/test", home.test_dir
        assert_equal "#{home.base}.rb", home.source
        const = home.base.split(?_).map(&:capitalize).join
        assert_equal const, home.const

        Dir.chdir(home_dir) do
          home = Home.new
          assert_equal home_dir.downcase, home.base
          assert_equal "#{home.base}/lib", home.lib
          assert_equal "#{home.base}/lib/#{home.base}", home.base_dir
          assert_equal "#{home.base}/test", home.test_dir
          assert_equal "#{home.base}.rb", home.source
          const = home.base.split(?_).map(&:capitalize).join
          assert_equal const, home.const
        end
      end
    end
  end

  describe '#home?' do
    it 'must return false for not cleon gem' do
      SpecTemp.() do
        refute Home.new.home?
      end
    end

    it 'must return true for cleon gem' do
      SpecTemp.() do
        _, _ = capture_subprocess_io { CloneCleon.(home_dir) }
        Dir.chdir(home_dir) { assert Home.new.home? }
      end
    end
  end
end
