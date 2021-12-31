require_relative "service"
require_relative "../model"
require_relative "../decor"

module Cleon
  module Services

    GuardModel = Cleon::ArGuard.new('model', 'must be Model',
      Proc.new {|v| v.is_a?(Model) })

    # Clone one concept
    class CloneConcept < Service
      def initialize(model:, path:)
        @meta = MetaGem.new(path)
        @path = path
        @thing = Model.new(model.split(' '))
        @model = Decor.new(@thing, @meta.const)
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
        body = File.read(File.join(@path, include)) + "\n#{excerpt}"
        write_file(include, body)
      end

      def write_file(name, content)
        filename = File.join(@path, name)
        if File.exist?(filename)
          FileUtils.cp filename, filename + '~'
          @log << name + '~'
        end
        File.write(filename, content)
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
