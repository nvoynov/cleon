require_relative '../spec_helper'
include Cleon

describe Generator do

  describe '#call' do

    let(:erb) { '<%= @model %>' }
    let(:out) { 'spec.rb' }
    let(:req) { 'req.rb' }
    let(:required) { "require_relative 'req'" }
    let(:new_required) {
      <<~EOF
        #{required}
        require_relative 'spec'
      EOF
    }
    let(:path){ 'spec' }

    # initialize(model, erb:, path: Dir.pwd, place_to: require_to:)
    describe '#call(model, erb:, path: Dir.pwd)' do
      it 'must create source file' do
        SpecTmp.() do
          Generator.(1, erb: erb, place_to: out)
          assert File.exist?(out)
          assert_equal '1', File.read(out)

          Dir.mkdir path
          Generator.(1, erb: erb, place_to: out, path: path)
          assert File.exist?("#{path}/#{out}")
          assert_equal '1', File.read("#{path}/#{out}")
        end
      end

      it 'must create source file and require created' do
        SpecTmp.() do
          File.write(req, required)
          Generator.(1, erb: erb, place_to: out, require_to: req)
          assert File.exist?(req)
          assert_equal new_required, File.read(req) + "\n"

          Dir.mkdir path
          File.write("#{path}/#{req}", required)
          Generator.(1, erb: erb, place_to: out, require_to: req, path: path)
          assert File.exist?("#{path}/#{out}")
          assert_equal new_required, File.read("#{path}/#{req}") + "\n"
        end
      end
    end

  end

end
