require_relative '../basics/service'
require_relative '../explorer'

module Cleon
  module Services

    # Clone services from Cleon's gem into home gem
    #
    # @example the following command will get services from gem 'auth'
    #   and place service ports of Auth::Services under lib/root/ports folder
    #   it also will place lib/root/ports.rb with all those ports required
    #
    #   PortCleonServices.('auth', 'ports')
    #
    class PortServices < Service

      # @param get_from [String] the Cleon's gem where to get services from
      # @param place_to [String] the folder for placing service ports
      def initialize(get_from, place_to)
        # TODO: inside a gem or just everywhere ?
        @get_from = get_from
        @place_to = place_to
      end

      def call
        # TODO: create service_port template
        # TODO: check ports folder
        #       - create when not exist
        #       - fail when exist
        # TODO: clone service_port, in basics or @place_to?
        # TODO: create service_port descendant for each service in @get_from
        # TODO: create require_relative '@place_to/port_descendant'
        # TODO: create demo library class
        #       that accepts the same parameters as target service
        #       that just call appropriate port_descendant 
        bundle = Cleon::Explorer.(@get_from)
        bundle.each do |bu|
          bu[:service]
          bu[:params]
          bu[:args]
          bu[:helper]
        end
      end

    end

  end
end
