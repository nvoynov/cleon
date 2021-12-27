require_relative '../arguards'
require "forwardable"

module Cleon
  module Services

    class Service
      include Cleon::ArGuards
      extend Forwardable
      def_delegator :Cleon, :gateway

      if RUBY_VERSION =~ /3\.[[:digit:]]+\.[[:digit:]]/
        def self.call(*args, **opts)
          new(*args, **opts).call
        end
      else
        def self.call(*args)
          new(*args).call
        end
      end

      private_class_method :new

      # Should be implemented in subclasses
      def call
      end
    end

  end
end
