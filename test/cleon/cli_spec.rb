require_relative '../spec_helper'
include Cleon

describe CLI do

  let(:streamer) { /-= Cleon v#{Cleon::VERSION}/ }

  describe 'banner' do
    it 'must print banner' do
      out, _ = capture_io { CLI.banner }
      assert_match streamer, out
    end
  end

  describe 'clone' do
    it 'must error when not a gem' do
      SpecTmp.() do
        out, _ = capture_io { CLI.clone }
        assert_match CLI::ERR_GEM_REQUIRED, out
      end
    end

    it 'must error when already cloned' do
      SpecTmp.() do
        # out, err = capture_io { CLI.clone }
        out, _ = capture_io {
          CLI.clone
          CLI.clone
        }
        assert CLI::ERR_CLEON_CLONED, out.lines.last
      end
    end

    let(:clone_output) {
      <<~EOF
        Clone myself...
          created lib/clone/entities
          created lib/clone/services
          created lib/clone/gateways
          created test/clone
          created test/clone/services
          created test/clone/entities
          created lib/clone/arguard.rb
          created lib/clone/arguards.rb
          created lib/clone.rb~
          created lib/clone.rb
          created lib/clone/entities.rb
          created lib/clone/gateways.rb
          created lib/clone/services.rb
          created lib/clone/services/service.rb
          created lib/clone/entities/entity.rb
          created lib/clone/gateways/gateway.rb
        Cleon was successfully cloned
      EOF
    }

    it 'must clone' do
      SpecClone.('clone') do
        out, _ = capture_io { CLI.clone }
        assert clone_output, out
      end
    end
  end

  let(:temp) { 'temp' }
  let(:thing){ 'thing para1 para2' }

  describe 'service' do
    let(:output) {
      <<~EOF
        Clone entity...
          created lib/clone/services/thing.rb
          created lib/clone/services.rb~
          created lib/clone/services.rb
          created test/clone/services/thing_spec.rb
      EOF
    }

    it 'must error when not a gem' do
      SpecClone.('clone') do
        out, _ = capture_io { CLI.service(thing) }
        assert CLI::ERR_GEM_REQUIRED, out
      end
    end

    it 'must error when not cleoned' do
      skip 'need SpecGem not cleoned'
    end

    it 'must clone servive' do
      SpecClone.('clone') do
        out, _ = capture_io {
          CLI.clone
          CLI.service(thing)
        }
        assert output, out
      end
    end
  end

  describe 'entity' do
    let(:output) {
      <<~EOF
        Clone entity...
          created lib/clone/entities/thing.rb
          created lib/clone/entities.rb~
          created lib/clone/entities.rb
          created test/clone/entities/thing_spec.rb
      EOF
    }

    it 'must error when not a gem' do
      SpecClone.('clone') do
        out, _ = capture_io { CLI.entity(thing) }
        assert CLI::ERR_GEM_REQUIRED, out
      end
    end

    it 'must error when not cleoned' do
      skip 'need SpecGem not cleoned'
    end

    it 'must clone entity' do
      SpecClone.('clone') do
        out, _ = capture_io {
          CLI.clone
          CLI.entity(thing)
        }
        # puts out
        assert output, out
      end
    end
  end
end
