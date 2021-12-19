require_relative "../spec_helper"
include Cleon::Services

describe CloneCleonCode do

  def inside_sandbox
    Dir.mktmpdir(['cleon']) do |dir|
      Dir.chdir(dir) { yield }
    end
  end

  def inside_fake_gem
    inside_sandbox do
      Dir.mkdir 'cleon_clone'
      Dir.chdir 'cleon_clone' do
        Dir.mkdir 'lib'
        Dir.mkdir File.join('lib', 'cleon_clone')
        File.write 'cleon_clone.gemspec', ''
        File.write File.join('lib', 'cleon_clone.rb'), ''
      end
      yield
    end
  end

  describe '#call' do
    let(:wrong) { 'wrong' }

    it 'must raise Cleon::Error for wrong :path' do
      inside_fake_gem do
        err = assert_raises(Cleon::Error) { CloneCleonCode.(wrong) }
        assert_match %r{No such directory}, err.message
      end
    end

    it 'must raise Cleon::Error when .gemspec not found' do
      inside_fake_gem do
        Dir.mkdir(wrong)
        err = assert_raises(Cleon::Error) { CloneCleonCode.(wrong) }
        assert_match %r{Not gem directory}, err.message
      end
    end

    it 'must clone Cleon sources to :path' do
      inside_fake_gem do
        CloneCleonCode.('cleon_clone')
        cleon_sources = Dir.chdir(Cleon.root) { Dir.glob('lib/**/*.rb') }
        cleon_sources.delete_if{|s| s =~ /clone_cleon_code.rb$/}
        cleon_sources.each do |source|
          if source =~ /cleon.rb$/
            target = File.join("cleon_clone", "lib", "cleon_clone.rb")
            assert File.exist?(target)
            assert_match %r{module CleonClone}, File.read(target)
          else
            target = File.join("cleon_clone", source)
            target.gsub!('cleon/', 'cleon_clone/')
            assert File.exist?(target)
          end
        end
      end
    end

  end
end
