require_relative '../../spec_helper'

module SharedEntity
  extend Minitest::Spec::DSL

  let(:log) {
    <<~EOF.lines.map(&:strip)
      lib/#{cleon_clone}/entities/#{entity}.rb
      lib/#{cleon_clone}/entities.rb~
      lib/#{cleon_clone}/entities.rb
      test/#{cleon_clone}/entities/#{entity}_spec.rb
    EOF
  }

  def check_result(output)
    assert_equal log, output
    assert File.exist?(log.first)
    assert File.exist?(log.last)
    source = File.read(log[-2])
    includ = File.basename(log.first, '.rb')
    assert_match %r{require_relative 'entities/#{includ}'}, source
  end
end
#
# describe 'SharedEntity' do
#   include SharedEntity
#
#   let(:cleon_clone) { 'cleon_clone' }
#   let(:entity) { 'something' }
#   let(:model) { "#{entity} para1 para2:string" }
#
#   it 'must create service' do
#     capture_subprocess_io do
#       SpecCleon.(cleon_clone) do
#         log = CloneEntity.(model)
#         check_result(log)
#       end
#     end
#   end
#
# end
