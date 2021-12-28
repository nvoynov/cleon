require_relative "../../spec_helper"
include Cleon::Services

describe CloneThing do

  let(:root)  { 'thing' }
  let(:thing) { 'something para1 para2' }
  let(:decor) { Cleon::Decor.new(Cleon::Model.new(thing.split(' '))) }

  module SharedSpec
    extend Minitest::Spec::DSL

    # TODO: it must return what it created?
    it 'must create thing' do
      SpecGem.(root) do
        log = CloneThing.(type: type, thing: thing, path: Dir.pwd)
        assert_equal 3, log.size
        assert File.exist?(src)
        assert File.exist?(spec)
        last_req = File.read(inc).split(?\n).last
        assert_equal req, last_req
      end
    end
  end

  describe 'clone service' do
    include SharedSpec

    let(:type) { :service }
    let(:src)  { "lib/#{root}/services/#{decor.source}" }
    let(:inc)  { "lib/#{root}/services.rb" }
    let(:spec) { "test/#{root}/services/#{decor.spec}" }
    let(:req)  { "require_relative 'services/#{decor.name}'" }
  end

  describe 'clone entity' do
    include SharedSpec

    let(:type) { :entity }
    let(:src)  { "lib/#{root}/entities/#{decor.source}" }
    let(:inc)  { "lib/#{root}/entities.rb" }
    let(:spec) { "test/#{root}/entities/#{decor.spec}" }
    let(:req)  { "require_relative 'entities/#{decor.name}'" }
  end
end
