require_relative 'version'
require_relative 'services'
require_relative 'home'
include Cleon::Services

module Cleon
  module CLI
    extend self

    # Helper for CloneCleon.() (see Cleon::Services::CloneCleon.new)
    def clone(name)
      log = []
      guard_stderr do
        not_exist!(name.downcase)
        puts "Clone myself to '#{name}'..."
        log = CloneCleon.(name)
        print_log(log)
      end
      puts "Cleon was cloned successfully"
      log
    end

    # Helper for Cleon::Services::CloneGuard.()
    def arguard(name)
      log = []
      guard_stderr do
        inside_home!
        puts "Create arguard '#{name}'..."
        log = CloneGuard.(name.downcase)
        print_log(log)
      end
      puts "ArGuard was created successfully"
      log
    end

    # Helper for CloneThing.() (see Cleon::Services::CloneThing.new)
    def entity(model)
      log = []
      guard_stderr do
        inside_home!
        puts "Create entity..."
        log = CloneEntity.(model)
        print_log(log)
      end
      log
    end

    # Helper for CloneThing.() (see Cleon::Services::CloneThing.new)
    def service(model)
      log = []
      guard_stderr do
        inside_home!
        puts "Create service..."
        log = CloneService.(model)
        print_log(log)
      end
      log
    end

    def banner
      puts BANNER
    end

    DIR_EXIST = 'Cannot clone Cleon into an existing folder'
    CLEON_REQ = 'Cannot clone outside of Cleon\'s gem'
    GEM_REQ   = 'Cannot clone outside a gem'

    private

    def not_exist!(dir)
      Cleon.error!(DIR_EXIST) if Dir.exist?(dir)
    end

    def inside_home!
      Cleon.error!(CLEON_REQ) unless Cleon::Home.new.home?
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
        1. gem "cleon" when your work with Bundler
        2. $ cleon

      Commands:
        $ cleon CLONE
        $ cleon arguard NAME
        $ cleon service NAME [PARA1 PARA2]
        $ cleon entity NAME [PARA1 PARA2]
        $ cleon port CLEON PORT_TO
    EOF
  end
end
