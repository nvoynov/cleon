# frozen_string_literal: true

require_relative "cleon/version"
require_relative "cleon/arguard"
require_relative "cleon/arguards"
require_relative "cleon/entities"
require_relative "cleon/services"
require_relative "cleon/gateways"
require_relative "cleon/generator"
require_relative "cleon/metagem"
require_relative "cleon/model"
require_relative "cleon/decor"

module Cleon
  class Error < StandardError; end

  # TODO: prepare clean CleonClone module instead of this
  #       without those root, file, base, clone_cleon_code
  class << self

    # Helper for CloneCleon.() (see Cleon::Services::CloneCleon.new)
    def clone_cleon(path = Dir.pwd)
      Cleon::Services::CloneCleon.(path)
    end

    # Helper for CloneThing.() (see Cleon::Services::CloneThing.new)
    def clone_entity(thing, path = Dir.pwd)
      Cleon::Services::CloneThing.(type: 'entity', thing: thing, path: path)
    end

    # Helper for CloneThing.() (see Cleon::Services::CloneThing.new)
    def clone_service(thing, path = Dir.pwd)
      Cleon::Services::CloneThing.(type: 'service', thing: thing, path: path)
    end

    def root
      File.dirname __dir__
    end

    def error!(message)
      raise Error.new(message)
    end

    GuardGateway = Cleon::ArGuard.new(
      "gateway", "must be Cleon::Gateways::Gateway",
      Proc.new {|v| v.is_a? Cleon::Gateways::Gateway})

    def gateway
      @gateway # ||= Cleon::Gateways::Gateway.new
    end

    def gateway=(gateway)
      @gateway = GuardGateway.(gateway)
    end
  end
end
