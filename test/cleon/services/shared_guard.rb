require_relative '../../spec_helper'

module SharedGuard
  extend Minitest::Spec::DSL

  let(:log) {
    <<~EOF.lines.map(&:strip)
      lib/#{cleon_clone}/arguards.rb~
      lib/#{cleon_clone}/arguards.rb
      test/#{cleon_clone}/arguards_spec.rb
      test/#{cleon_clone}/arguards_spec.rb~
      test/#{cleon_clone}/arguards_spec.rb
    EOF
  }

  def check_result(output)
    assert_equal log, output
    source = File.read(log[1])
    const = Home.new.const
    guard_class = "Guard#{arguard.capitalize} = #{const}::ArGuard.new"
    assert_match %r{#{guard_class}}, source
    # puts "\n--- arguards.rb\n#{File.read(log[1])}\n--- arguards_spec.rb\n#{File.read(log.last)}"
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
#     puts out
#   end
# end
