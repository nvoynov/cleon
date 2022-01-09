require_relative "../../spec_helper"
require_relative "shared_clone"
include Cleon::Services

describe CloneCleon do
  include SharedClone

  let(:cleon_clone) { 'cleon_clone' }

  it 'must raise when directory exits' do
    capture_subprocess_io do
      SpecTemp.() do
        Dir.mkdir(cleon_clone)
        err = assert_raises(Cleon::Error) { CloneCleon.(cleon_clone) }
        assert_match %r{Cannot clone to an existing folder}, err.message
      end
    end
  end

  it 'must create a gem and clone' do
    capture_subprocess_io do
      SpecTemp.() do
        log = CloneCleon.(cleon_clone)
        check_result(log)
      end
    end
  end
end
