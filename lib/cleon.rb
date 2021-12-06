# frozen_string_literal: true

require_relative "cleon/version"
require_relative "cleon/entities"
require_relative "cleon/services"
require_relative "cleon/gateways"
require_relative "cleon/argchkr"

module Cleon
  class Error < StandardError; end

  class << self

    def root
      File.dirname __dir__
    end

    # Clone source code to another gem
    # @param path [String] the root folder of the gem to copy
    def clone_cleon_code(path = Dir.pwd)
      Cleon::Services::CloneCleonCode.(path)
    end

    CleonGateway = Cleon::ArgChkr::Policy.new(
      "gateway", ":%s must be Cleon::Gateways::Gateway",
      Proc.new {|v| v.is_a? Cleon::Gateways::Gateway})

    def gateway
      @gateway # ||= Cleon::Gateways::Gateway.new
    end

    def gateway=(gateway)
      @gateway = CleonGateway.chk!(gateway)
    end
  end
end
