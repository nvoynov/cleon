module Cleon

  # Gem matainformation
  # @example
  #   meta = MetaGem.new(Dir.pwd)
  #   meta.gemspec
  #   meta...
  class MetaGem

    def initialize(path = Dir.pwd)
      @path = path
    end

    def gem?
      return false unless gemspec
      Dir.exist?(lib)
    end

    def gemspec
      @gemspec ||= Dir.chdir(@path) { Dir.glob('*.gemspec').first }
    end

    def base
      @base ||= File.basename(gemspec, '.gemspec')
    end

    def base_dir
      @bdir ||= File.join(lib, base)
    end

    def lib
      @lib ||= File.join(@path, 'lib')
    end

    def source
      @source ||= "#{base}.rb"
    end

    def const
      @const ||= base.split(?_).map(&:capitalize).join
    end
  end

end
