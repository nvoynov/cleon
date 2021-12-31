require_relative 'version'

module Cleon
  module CLI
    extend self

    # Helper for CloneCleon.() (see Cleon::Services::CloneCleon.new)
    def clone(path = Dir.pwd)
      guard_stderr do
        Cleon.error!(ERR_GEM_REQUIRED) unless gem?(path)
        Cleon.error!(ERR_CLEON_CLONED) if cleon_gem?(path)
        puts "Clone myself..."
        log = Cleon::Services::CloneCleon.(path)
        print_log(log)
      end
      puts "Cleon was successfully cloned"
    end

    # Helper for CloneThing.() (see Cleon::Services::CloneThing.new)
    def entity(model, path = Dir.pwd)
      guard_stderr do
        Cleon.error!(ERR_CLEON_REQUIRED) unless cleon_gem?(path)
        puts "Clone entity..."
        log = Cleon::Services::CloneEntity.(model: model, path: path)
        print_log(log)
      end
    end

    # Helper for CloneThing.() (see Cleon::Services::CloneThing.new)
    def service(model, path = Dir.pwd)
      guard_stderr do
        Cleon.error!(ERR_CLEON_REQUIRED) unless cleon_gem?(path)
        puts "Clone entity..."
        log = Cleon::Services::CloneService.(model: model, path: path)
        print_log(log)
      end
    end

    def banner
      puts BANNER
    end

    ERR_GEM_REQUIRED = 'This command only works inside a gem'
    ERR_CLEON_REQUIRED = 'This command only works inside a "cleoned" gem'
    ERR_CLEON_CLONED = 'This gem is already "cleoned"'

    private

    def gem?(path)
      MetaGem.new(path).gem?
    end

    def cleon_gem?(path)
      MetaGem.new(path).cleon_gem?
    end

    def print_log(log)
      log.each{|l| puts "  created #{l}"}
    end

    def guard_stderr
      yield
    rescue StandardError => e
      puts e.message
      banner
    end

    BANNER = <<~EOF
      -= Cleon v#{Cleon::VERSION} =- Clean Code Skeleton
      home: https://github.com/nvoynov/cleon

      Quickstart:
        1. gem "cleon"
        2. $ cleon clone

      Commands:
        $ cleon clone
        $ cleon service NAME [PARA1 PARA2]
        $ cleon entity NAME [PARA1 PARA2]
    EOF
  end
end
