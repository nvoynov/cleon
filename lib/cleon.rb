# frozen_string_literal: true

require_relative "cleon/version"
require_relative "cleon/arguard"
require_relative "cleon/gateway"
require_relative "cleon/arguards"
require_relative "cleon/entities"
require_relative "cleon/services"
require_relative "cleon/metagem"
require_relative "cleon/model"
require_relative "cleon/decor"
require_relative "cleon/cli"

module Cleon
  class Error < StandardError; end

  class << self

    def root
      File.dirname __dir__
    end

    def error!(message)
      raise Error.new(message)
    end

    GuardGateway = Cleon::ArGuard.new(
      "gateway", "must be Cleon::Gateways::Gateway",
      Proc.new {|v| v.is_a? Cleon::Gateway})

    def gateway
      @gateway # ||= Cleon::Gateways::Gateway.new
    end

    def gateway=(gateway)
      @gateway = GuardGateway.(gateway)
    end
  end
end
