require_relative "service"
require_relative "../model"
require_relative "../decor"

module Cleon
  module Services

    GuardThing = ArGuard.new('thing', 'must be :service or :entity',
      Proc.new {|v| v.to_s.downcase.then{|t| t == 'service' || t == 'entity'}})

    # The service clones one of Cleon main concepts - service or entity
    class CloneThing < Service

      def initialize(type:, thing:, path: Dir.pwd)
        @path = path
        @type = GuardThing.(type).to_s
        @meta = MetaGem.new
        @thing = Cleon::Model.new(thing.split(' '))
        @model = Decor.new(@thing, @meta.const)
      end

      def call
        log = []
        settings = SETTINGS[@type.to_sym]

        # create thing
        src = File.join(Cleon.root, settings[:erb_tt])
        erb = File.read(src)
        put = settings[:put_to] % {base: @meta.base, name: @model.source}
        req = settings[:req_to] % {base: @meta.base}
        Generator.(@model, path: @path, erb: erb,
          place_to: put, require_to: req)
        log << "'#{put}' created"
        log << "'#{put}' required in '#{req}'"

        # create the thing's spec
        src = File.join(Cleon.root, settings[:spec][:erb_tt])
        erb = File.read(src)
        put = settings[:spec][:put_to] % {base: @meta.base, name: @model.spec}

        Generator.(@model, path: @path, erb: erb, place_to: put)
        log << "'#{put}' created"

        log
      end

      SETTINGS = {
        service: {
          erb_tt: 'lib/erb/service.rb.erb',
          put_to: 'lib/%{base}/services/%{name}',
          req_to: 'lib/%{base}/services.rb',
          spec: {
            erb_tt: 'lib/erb/service_spec.rb.erb',
            put_to: 'test/%{base}/services/%{name}'
          }
        },

        entity: {
          erb_tt: 'lib/erb/entity.rb.erb',
          put_to: 'lib/%{base}/entities/%{name}',
          req_to: 'lib/%{base}/entities.rb',
          spec: {
            erb_tt: 'lib/erb/entity_spec.rb.erb',
            put_to: 'test/%{base}/entities/%{name}'
          }
        }
      }
    end

  end
end
