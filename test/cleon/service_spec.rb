require_relative "../spec_helper"
include Cleon::Services

describe Service do
  class SpecService < Cleon::Services::Service
    def self.service
      new
    end
  end

  before do
    Cleon.gateway = Cleon::Gateways::Gateway.new
  end

  it 'must provide gateway' do
    assert_respond_to SpecService.service, :gateway
  end

end
