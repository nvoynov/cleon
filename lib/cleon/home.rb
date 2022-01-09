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
        # patch_gemspec
      end
    end
    #
    # def patch_gemspec
    #   original = File.read(gemspec)
    #   File.write("#{gemspec}.rb", original)
    #   original.lines.tap do |lines|
    #     index = lines.index{|l| l =~ %r{spec.summary}}
    #     lines[index] = "spec.summary = " if index
    #   end

  # spec.summary       = "TODO: Write a short summary, because RubyGems requires one."
  # spec.description   = "TODO: Write a longer description or delete this line."
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  # spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")
  #
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #
  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

    # end

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

    # @return [String] filename of .gemspec
    def gemspec
      @gemspec ||= begin
        # hack for test generators inside fresh gem with TODO
        tmp = inside_home { Dir.glob('*.gemspec').first }
        tmp = File.basename(Dir.pwd) unless tmp
        tmp
      end
    end

  end
end
