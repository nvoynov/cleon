require_relative "../../spec_helper"
include Cleon::Services

describe CloneEntity do

  let(:root)  { 'thing' }
  let(:model) { 'something para1 para2' }
  let(:decor) { Cleon::Decor.new(Cleon::Model.new(model.split(' '))) }

  let(:code) { "lib/#{root}/entities/#{decor.source}" }
  let(:spec) { "test/#{root}/entities/#{decor.spec}"  }
  let(:inc)  { "lib/#{root}/entities.rb" }
  let(:req)  { "require_relative 'entities/#{decor.name}'" }
  let(:output) {
    <<~EOF.lines.map(&:strip)
      lib/thing/entities/something.rb
      lib/thing/entities.rb~
      lib/thing/entities.rb
      test/thing/entities/something_spec.rb
    EOF
  }

  it 'must clone entity' do
    SpecGem.(root) do
      log = nil
      _, _ = capture_io {log = CloneEntity.(model: model, path: Dir.pwd)}
      assert_equal output, log
      assert File.exist?(code)
      assert File.exist?(spec)
      last_req = File.read(inc).split(?\n).last
      assert_equal req, last_req
    end
  end

end
