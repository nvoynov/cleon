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

        write_file(arguards_spec, shared_spec) unless File.exist?(arguards_spec)
        source = File.read(arguards_spec)
        write_file(arguards_spec, source + spec_content)
        @log
      end

      def guard_content
        <<~EOF.lines.map{|l| ' '*4 + l}
          Guard#{@model.const} = #{@model.root_const}::ArGuard.new(
            '#{@model.name.downcase}', 'must be #{@model.const}',
            Proc.new {|v|
              raise "provide spec for Guard#{@model.const} file: \#{__FILE__} line: \#{__LINE__}"})

        EOF
      end

      def arguards_source
        "lib/#{@home.base}/arguards.rb"
      end

      def arguards_spec
        "test/#{@home.base}/arguards_spec.rb"
      end

      def spec_content
        <<~EOF

          describe Guard#{@model.const} do
            include SharedGuardSpecs

            let(:guard) { Guard#{@model.const} }
            let(:valid) { [nil, -1, 0, 1, "", "str", Object.new] }
            let(:wrong) { [nil, -1, 0, 1, "", "str", Object.new] }
          end
        EOF
      end

      def shared_spec
        <<~EOF
          require_relative '../spec_helper'
          include #{@model.root_const}::ArGuards

          module SharedGuardSpecs
            extend Minitest::Spec::DSL

            # spec must provided the following variables:
            #   let(:guard) { GuardName }
            #   let(:valid) { ["name", :name] }
            #   let(:wrong) { [nil, 1, Object.new]}

            it 'must return value' do
              valid.each{|v| assert_equal v, guard.(v)}
            end

            it 'must raise ArgumentError' do
              wrong.each{|w| assert_raises(ArgumentError) { guard.(w) }}
            end
          end
        EOF
      end
    end

  end
end
