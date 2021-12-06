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
    def spawn_clone(gem_folder)
      # ensure that gem_folder is the folder of a gem
      # extract target gem name
      # clone lib folder to lib folder of the target gem, changing name
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
