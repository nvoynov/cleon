require_relative "clone_concept"

module Cleon
  module Services

    # Clone service
    class CloneService < CloneConcept

      # return configuration, must be provided in subclasses
      # @return [Hash] of keys code_erb, code_dir, spec_erb, spec_dir, inlcude
      def config
        {
          code_erb: "#{Cleon.root}/lib/erb/service.rb.erb",
          code_dir: "lib/#{@home.base}/services",
          spec_erb: "#{Cleon.root}/lib/erb/service_spec.rb.erb",
          spec_dir: "test/#{@home.base}/services",
          include: "lib/#{@home.base}/services.rb"
        }
      end
    end

  end
end
