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
          code_dir: "lib/#{@meta.base}/services",
          spec_erb: "#{Cleon.root}/lib/erb/service_spec.rb.erb",
          spec_dir: "test/#{@meta.base}/services",
          include: "lib/#{@meta.base}/services.rb"
        }
      end
    end
        #
        # {

        # }
        # cfg[:entity] = {
        #   code_erb: "#{Dogen.root}/lib/erb/entity.rb.erb",
        #   code_dir: "lib/#{@meta.base}/entities",
        #   spec_erb: "#{Dogen.root}/lib/erb/entity_spec.rb.erb",
        #   spec_dir: "test/#{@meta.base}/entities",
        #   include: "lib/#{@meta.base}/entities.rb"
        # }
        # }

  end
end
