require_relative "../../spec_helper"
require_relative "shared_entity"
include Cleon::Services

describe CloneEntity do
  include SharedEntity

  it 'must error when outside Cleon home' do
    SpecTemp.() do
      err = assert_raises(Cleon::Error) {CloneEntity.(model)}
      assert_match %r{t cannot be done outside a Cleon}, err.message
    end
  end

  let(:cleon_clone) { 'cleon_clone' }
  let(:entity) { 'something' }
  let(:model) { "#{entity} para1 para2:string" }

  it 'must create entity' do
    capture_subprocess_io do
      SpecCleon.(cleon_clone) do
        log = CloneEntity.(model)
        check_result(log)
      end
    end
  end

end
