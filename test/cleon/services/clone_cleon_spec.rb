require_relative "../../spec_helper"
include Cleon::Services

describe CloneCleon do

  # it 'must dry-run' do
  #   Dir.chdir('test/cleon_clone') do
  #     dirs =  ['lib', "lib/cleon_clone"]
  #     files = ["cleon_clone.gemspec", "lib/cleon_clone.rb"]
  #     dirs.each{|dir| Dir.mkdir(dir) unless Dir.exist?(dir) }
  #     files.each{|src| File.write(src, '')  unless File.exist?(src)}
  #     CloneCleon.()
  #   end
  # end

  describe '#call' do
    let(:wrong) { 'wrong' }

    it 'must raise Cleon::Error for wrong :path' do
      SpecTmp.() do
        err = assert_raises(Cleon::Error) { CloneCleon.(wrong) }
        assert_match %r{Unknown path}, err.message
      end
    end

    it 'must raise Cleon::Error when .gemspec not found' do
      SpecTmp.() do
        Dir.mkdir(wrong)
        err = assert_raises(Cleon::Error) { CloneCleon.(wrong) }
        assert_match %r{Unknown gem}, err.message
      end
    end

    let(:cleon_clone) { 'cleon_clone' }
    let(:dirs) {
      [
        "#{cleon_clone}/services",
        "#{cleon_clone}/entities"
      ]
    }
    let(:srcs) {
      [
        'arguard.rb',
        'gateway.rb',
        'arguards.rb',
        'services.rb',
        'entities.rb',
        'services/service.rb',
        'entities/entity.rb'
      ]
    }

    it 'must clone Cleon sources to :path' do
      SpecClone.('cleon_clone') do
        meta = Cleon::MetaGem.new
        _, _ = capture_io do
          CloneCleon.()

          # check structure
          Dir.chdir(meta.lib) { dirs.each {|dir| assert Dir.exist?(dir)} }
          Dir.chdir(meta.base_dir) { srcs.each {|src| assert File.exist?(src)} }
        end

        # check compile
        Dir.chdir(meta.lib) do
          ruby = "require './#{meta.source}'; puts '42'"
          out, _ = capture_subprocess_io { system "ruby -e \"#{ruby}\"" }
          assert_match %r{42}, out
        end
      end
    end

  end
end
