require_relative '../basics/service'
require_relative '../model'
require_relative '../decor'
require_relative '../home'

module Cleon
  module Services

    # Clone one concept
    class CloneConcept < Service
      # @param model [String] 'thing para para:guard'
      def initialize(model)
        @home = Home.new
        Cleon.error!("It cannot be done outside a Cleon's gem") unless @home.home?
        @thing = Model.new(model.split(' '))
        @model = Decor.new(@thing, @home.const)
      end

      def call
        @log = []
        builder = renderer(config[:code_erb])
        content = builder.result(binding)
        write_file(File.join(config[:code_dir], @model.source), content)
        do_require(@model.source, config[:include]) if config[:include]

        builder = renderer(config[:spec_erb])
        content = builder.result(binding)
        write_file(File.join(config[:spec_dir], @model.spec), content)

        @log
      end

      # require :include into :target
      def do_require(name, include)
        incl = name.sub(/.rb\z/, '')
        prfx = include =~ /services/ ? 'services' : 'entities'
        excerpt = "require_relative '#{prfx}/#{incl}'"
        body = File.read(include) + "\n#{excerpt}"
        write_file(include, body)
      end

      def write_file(name, content)
        if File.exist?(name)
          FileUtils.cp name, name + '~'
          @log << name + '~'
        end
        File.write(name, content)
        @log << name
      end

      # return renederer
      def renderer(source)
        erb = File.read(source)
        ERB.new(erb, trim_mode: '-')
      end

      # return configuration, must be provided in subclasses
      # @return [Hash] of keys code_erb, code_dir, spec_erb, spec_dir, inlcude
      def config
        {
          # code_erb: '',
          # code_dir: '',
          # spec_erb: '',
          # spec_dir: '',
          # include:  ''
        }
      end
    end

  end
end
