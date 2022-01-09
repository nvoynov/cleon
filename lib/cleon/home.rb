module Cleon

  # The cleon home folder information
  class Home
    attr_reader :home
    # when cloning cleon, the user is outside the home
    # when cloning thing, the user is inside the home
    def initialize(home = Dir.pwd)
      @home = File.basename(home).downcase
    end

    def exist?
      Dir.exist?(home)
    end

    def home?
      return false unless gemspec
      dirs.all?{|dir| Dir.exist?(dir)}
    end

    def inside_home?
      @home == File.basename(Dir.pwd)
    end

    def inside_home
      inside_home? ? yield : Dir.chdir(@home) { yield }
    end

    # Creates Cleon's gem structure
    # @returns [Array] log of created folders
    def bundle
      system "bundle gem #{@home} #{BUNDLE_OPTIONS}"
      log = []
      inside_home do
        dirs
          .select{|dir| !Dir.exist?(dir)}
          .each{|dir| Dir.mkdir(dir); log << dir}
      end
    end

    BUNDLE_OPTIONS = "--no-exe --no-coc --no-ext --no-mit --test=minitest"

    # @return [String] base name of the gem
    def base
      @base ||= File.basename(gemspec, '.gemspec').split('-').first.downcase
    end

    def lib
      @lib ||= File.join(home, 'lib')
    end

    def base_dir
      @bdir ||= File.join(lib, base)
    end

    def test_dir
      @tdir ||= File.join(home, 'test')
    end

    def source
      @source ||= "#{base}.rb"
    end

    def const
      @const ||= base.split(?_).map(&:capitalize).join
    end

    def dirs
      [ "lib/#{base}",
        "lib/#{base}/services",
        "lib/#{base}/entities",
        "test/#{base}",
        "test/#{base}/services",
        "test/#{base}/entities" ]
    end

    private

    # @return [String] filename of .gemspec
    def gemspec
      @gemspec ||= inside_home { Dir.glob('*.gemspec').first }
    end


  end
end
