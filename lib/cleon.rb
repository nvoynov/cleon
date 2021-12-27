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

    def root
      File.dirname __dir__
    end

    def base
      File.basename(__FILE__, ".rb")
    end

    def error!(message)
      raise Error.new(message)
    end

    # Clone source code to another gem
    # @param path [String] the root folder of the gem to copy
    def clone_cleon_code(path = Dir.pwd)
      Cleon::Services::CloneCleonCode.(path)
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
