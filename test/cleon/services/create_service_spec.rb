require_relative "../../spec_helper"
include Cleon::Services

describe CreateService do

  let(:entity) { %w(create_something para1 para2) }
  let(:model)  { Cleon::Model.new(entity) }
  let(:gemname){ 'something' }
  let(:decor)  { Cleon::Decor.new(model, gemname) }
  let(:source) { "lib/#{gemname}/services/#{decor.source_file}" }
  let(:spec)   { "test/#{gemname}/services/#{decor.source_file('spec')}" }
  let(:include)  { "lib/#{gemname}/services.rb"  }
  let(:include_content) {
    <<~EOF
      require_relative 'services/create_something'
    EOF
  }

  describe '#call' do
    it 'must create a new service and require it in services.rb' do
      SpecGem.(gemname) do
        CreateService.(model, gemname)
        assert File.exist?(source)
        assert_equal include_content, File.read(include).split(?\n).last + "\n"
        assert File.exist?(spec)
      end
    end
  end

end
