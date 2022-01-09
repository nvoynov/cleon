require_relative '../spec_helper'

class ServicePort
  def self.port(service)
    raise ArgumentError.new(
      "It must be class respond to :call"
    ) unless service.respond_to?(:call)
    @service = service
  end

  def self.ported
    @service
  end

  def ported
    self.class.ported
  end

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  def call
    decorate(ported.(ported_params))
  end

  def ported_params
    override!
  end

  def decorate(response)
    override!
  end

  def override!
    raise "Override it in subclass!"
  end
end

class SomeService < Cleon::Services::Service
  def initialize(name)
    @name = name
  end

  def call
    @name
  end
end

class SpecServicePort < ServicePort
  port SomeService

  def ported_params
    "Cleon"
  end

  def decorate(response)
    "-= #{response} =-"
  end
end

describe ServicePort do
  it 'dry-run' do
    assert_equal '-= Cleon =-', SpecServicePort.()
  end
end
