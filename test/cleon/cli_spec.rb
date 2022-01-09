require_relative '../spec_helper'
require_relative 'services/shared_clone'
require_relative 'services/shared_guard'
require_relative 'services/shared_service'
require_relative 'services/shared_entity'
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
    include SharedClone

    let(:cleon_clone) { 'cleon_clone' }

    it 'must error when folder exist' do
      capture_subprocess_io do
        SpecTemp.() do
          Dir.mkdir(cleon_clone)
          out, _ = capture_io { CLI.clone(cleon_clone) }
          assert_match CLI::DIR_EXIST, out
        end
      end
    end

    it 'must clone' do
      capture_subprocess_io do
        SpecTemp.() do
          log = nil
          _, _ = capture_io { log = CLI.clone(cleon_clone) }
          check_result(log)
          # TODO: check out
        end
      end
    end
  end

  let(:arguard) { 'string' }

  describe 'guard' do
    include SharedGuard

    let(:cleon_clone) { 'cleon_clone' }
    let(:arguard) { 'integer' }

    it 'must clone guard' do
      capture_subprocess_io do
        SpecCleon.(cleon_clone) do
          log = CLI.arguard(arguard)
          check_result(log)
        end
      end
    end
  end

  describe 'service' do
    include SharedService

    let(:cleon_clone) { 'cleon_clone' }
    let(:service) { 'something' }
    let(:model) { "#{service} para1 para2:string" }

    it 'must error when not a gem' do
      SpecTemp.() do
        out, _ = capture_io { CLI.service(model) }
        assert CLI::CLEON_REQ, out
      end
    end

    it 'must clone servive' do
      capture_subprocess_io do
        SpecCleon.(cleon_clone) do
          log = nil
          _, _ = capture_io { log = CLI.service(model) }
          check_result(log)
        end
      end
    end
  end

  describe 'entity' do
    include SharedEntity

    let(:cleon_clone) { 'cleon_clone' }
    let(:entity) { 'something' }
    let(:model) { "#{entity} para1 para2:string" }

    it 'must error when not a gem' do
      SpecTemp.() do
        out, _ = capture_io { CLI.entity(model) }
        assert CLI::CLEON_REQ, out
      end
    end

    it 'must clone entity' do
      capture_subprocess_io do
        SpecCleon.(cleon_clone) do
          log = nil
          _, _ = capture_io { log = CLI.entity(model) }
          check_result(log)
        end
      end
    end
  end
end
