require_relative "clone_concept"

module Cleon
  module Services

    # Clone service
    class CloneEntity < CloneConcept

      # return configuration, must be provided in subclasses
      # @return [Hash] of keys code_erb, code_dir, spec_erb, spec_dir, inlcude
      def config
        {
          code_erb: "#{Cleon.root}/lib/erb/entity.rb.erb",
          spec_erb: "#{Cleon.root}/lib/erb/entity_spec.rb.erb",
          code_dir: "lib/#{@home.base}/entities",
          spec_dir: "test/#{@home.base}/entities",
          include: "lib/#{@home.base}/entities.rb"
        }
      end
    end

  end
end
