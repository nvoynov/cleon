require_relative "../spec_helper"
include Cleon::Services

describe Service do
  class SpecService < Service
    public_class_method :new
  end

  before do
    Cleon.gateway = Cleon::Gateway.new
  end

  it 'must provide gateway' do
    assert_respond_to SpecService.new, :gateway
  end

end
