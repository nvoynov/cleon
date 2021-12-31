require_relative "../../spec_helper"
include Cleon::Services

describe CloneService do

  let(:root)  { 'thing' }
  let(:model) { 'something para1 para2' }
  let(:decor) { Cleon::Decor.new(Cleon::Model.new(model.split(' '))) }

  let(:code) { "lib/#{root}/services/#{decor.source}" }
  let(:spec) { "test/#{root}/services/#{decor.spec}"  }
  let(:inc)  { "lib/#{root}/services.rb" }
  let(:req)  { "require_relative 'services/#{decor.name}'" }
  let(:output) {
    <<~EOF.lines.map(&:strip)
      lib/thing/services/something.rb
      lib/thing/services.rb~
      lib/thing/services.rb
      test/thing/services/something_spec.rb
    EOF
  }

  it 'must clone entity' do
    SpecGem.(root) do
      log = nil
      _, _ = capture_io {log = CloneService.(model: model, path: Dir.pwd)}
      assert_equal output, log
      assert File.exist?(code)
      assert File.exist?(spec)
      last_req = File.read(inc).split(?\n).last
      assert_equal req, last_req
      # puts File.read(code)
      # puts File.read(spec)
    end
  end

end
