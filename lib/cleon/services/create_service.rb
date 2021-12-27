require_relative "service"
require_relative "../model"
require_relative "../decor"

module Cleon
  module Services

    # The service creates a new entity under entities/ and require it
    class CreateService < Service

      # @param model [Model] the model for generation
      # @param root [String] the owner of the model, main module
      def initialize(model, root)
        @model = Decor.new(GuardModel.(model), root)
      end

      def call
        erb_src = File.join(Cleon.root, 'lib', 'erb', 'service.rb.erb')
        erb = File.read(erb_src)
        Generator.(@model, erb: erb,
          place_to:   "lib/#{@model.root}/services/#{@model.source_file}",
          require_to: "lib/#{@model.root}/services.rb")

        # generate spec
        erb_src = File.join(Cleon.root, 'lib', 'erb', 'service_spec.rb.erb')
        erb = File.read(erb_src)
        dest = "test/#{@model.root}/services/#{@model.source_file('spec')}"
        Generator.(@model, erb: erb, place_to: dest)
      end
    end

  end
end
