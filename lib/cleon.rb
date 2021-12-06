# frozen_string_literal: true

require_relative "cleon/version"
require_relative "cleon/entities"
require_relative "cleon/services"
require_relative "cleon/gateways"
require_relative "cleon/argchkr"

module Cleon
  class Error < StandardError; end

  class << self
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
