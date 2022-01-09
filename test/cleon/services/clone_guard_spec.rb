require_relative '../../spec_helper'
require_relative 'shared_guard'
include Cleon::Services

describe CloneGuard do
  include SharedGuard

  let(:cleon_clone) { 'cleon_clone' }
  let(:arguard) { 'string' }

  it 'must create arguard' do
    _, _ = capture_subprocess_io do
      SpecCleon.(cleon_clone) do
        log = CloneGuard.(arguard)
        check_result(log)
      end
    end
  end
end
