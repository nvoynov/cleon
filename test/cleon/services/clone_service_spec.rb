require_relative "../../spec_helper"
require_relative "shared_service"
include Cleon::Services

describe CloneService do
  include SharedService

  it 'must error when outside Cleon home' do
    SpecTemp.() do
      err = assert_raises(Cleon::Error) {CloneService.(model)}
      assert_match %r{t cannot be done outside a Cleon}, err.message
    end
  end

  let(:cleon_clone) { 'cleon_clone' }
  let(:service) { 'something' }
  let(:model) { "#{service} para1 para2:string" }

  it 'must create service' do
    capture_subprocess_io do
      SpecCleon.(cleon_clone) do
        log = CloneService.(model)
        check_result(log)
      end
    end
  end

end
