require_relative '../../spec_helper'

module SharedService
  extend Minitest::Spec::DSL

  let(:log) {
    <<~EOF.lines.map(&:strip)
      lib/#{cleon_clone}/services/#{service}.rb
      lib/#{cleon_clone}/services.rb~
      lib/#{cleon_clone}/services.rb
      test/#{cleon_clone}/services/#{service}_spec.rb
    EOF
  }

  def check_result(output)
    assert_equal log, output
    assert File.exist?(log.first)
    assert File.exist?(log.last)
    source = File.read(log[-2])
    includ = File.basename(log.first, '.rb')
    assert_match %r{require_relative 'services/#{includ}'}, source
  end
end

# describe 'ShardService' do
#   include SharedService
#
#   let(:cleon_clone) { 'cleon_clone' }
#   let(:service) { 'something' }
#   let(:model) { "#{service} para1 para2:string" }
#
#   it 'must create service' do
#     capture_subprocess_io do
#       SpecCleon.(cleon_clone) do
#         log = CloneService.(model)
#         check_result(log)
#       end
#     end
#   end
#
# end
