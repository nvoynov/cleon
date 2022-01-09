require_relative "clone_concept"

module Cleon
  module Services

    # Clone argument guard
    class CloneGuard < CloneConcept

      # add new arguard into arguards.rb at the bottom of ArGuards module
      def call
        # Cleon.error! unless @home.home?
        # @thing = Model.new(model.split(' '))
        # @model = Decor.new(@thing, @home.const)
        @log = []
        source = File.read(arguards_source).lines
        source.insert(-3, guard_content)
        # it will write also copy into source.rb~
        write_file(arguards_source, source.join)
        @log
      end

      def guard_content
        <<~EOF.lines.map{|l| ' '*4 + l}
          Guard#{@model.const} = #{@model.root_const}::ArGuard.new(
            '#{@model.name.downcase}', 'must be #{@model.const}',
            Proc.new {|v| raise 'provide Guard#{@model.const} spec'})

        EOF
      end

      def arguards_source
        "lib/#{@home.base}/arguards.rb"
      end

    end

  end
end
