require_relative '../../spec_helper'

module SharedGuard
  extend Minitest::Spec::DSL

  let(:log) {
    <<~EOF.lines.map(&:strip)
      lib/#{cleon_clone}/arguards.rb~
      lib/#{cleon_clone}/arguards.rb
    EOF
  }

  def check_result(output)
    assert_equal log, output
    source = File.read(log.last)
    const = Home.new.const
    guard_class = "Guard#{arguard.capitalize} = #{const}::ArGuard.new"
    assert_match %r{#{guard_class}}, source
  end

end

# describe 'ShardGuard' do
#   include SharedGuard
#
#   let(:cleon_clone) { 'cleon_clone' }
#   let(:arguard) { 'string' }
#
#   it 'must create arguard' do
#     out, _ = capture_io do
#       SpecCleon.(cleon_clone) do
#         log = CloneGuard.(arguard)
#         check_result(log)
#       end
#     end
#   end
# end
