require_relative "../spec_helper"
include Cleon::Services

describe CloneCleonSources do

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
      # puts ">> inside_fake_gem (#{Dir.pwd})\n #{Dir.glob('**/*')}"
      yield
    end
  end

  describe '#call' do
    it 'must raise ArgumentError for wrong :path_to_clone' do
      inside_fake_gem do
        path = File.join(Dir.pwd, 'unknown')
        _( ->{ CloneCleonSources.(path) } ).must_raise ArgumentError
      end
    end

    it 'must raise ArgumentError when .gemspec not found' do
      inside_fake_gem do
        path = File.join(Dir.pwd, 'unknown')
        Dir.mkdir(path)
        _( ->{ CloneCleonSources.(path) } ).must_raise ArgumentError
      end
    end

    it 'must raise Cleon::Error when .gemspec has -' do
      inside_fake_gem do
        path = File.join(Dir.pwd, 'few-words-gem')
        Dir.mkdir(path)
        File.write(File.join(path, 'few-words-gem.gemspec'), '')
        _( ->{ CloneCleonSources.(path) } ).must_raise Cleon::Error
      end
    end

    it 'must clone Cleon sources to :path_to_clone' do
      inside_fake_gem do
        CloneCleonSources.('cleon_clone')
        cleon_sources = Dir.chdir(Cleon.root) { Dir.glob('lib/**/*.rb') }
        cleon_sources.each do |source|
          # ! special case to ignore
          next if source =~ /clone_cleon_sources.rb$/
          
          if source =~ /cleon.rb$/
            target = File.join("cleon_clone", "lib", "cleon_clone.rb")
            _(File.exist?(target)).must_equal true
            _(File.read(target)).must_match(/module CleonClone/)
          else
            target = File.join("cleon_clone", source)
            target.gsub!('cleon/', 'cleon_clone/')
            _(File.exist?(target)).must_equal true
          end
        end
      end
    end

  end
end
