require_relative '../../spec_helper'

module SharedClone
  extend Minitest::Spec::DSL

  let(:log) {
    <<~EOF.lines.map(&:strip)
      lib/#{cleon_clone}/services
      lib/#{cleon_clone}/entities
      test/#{cleon_clone}
      test/#{cleon_clone}/services
      test/#{cleon_clone}/entities
      lib/#{cleon_clone}/arguard.rb
      lib/#{cleon_clone}/arguards.rb
      lib/#{cleon_clone}.rb~
      lib/#{cleon_clone}.rb
      lib/#{cleon_clone}/entities.rb
      lib/#{cleon_clone}/gateway.rb
      lib/#{cleon_clone}/services.rb
      lib/#{cleon_clone}/services/service.rb
      lib/#{cleon_clone}/entities/entity.rb
    EOF
  }

  def check_result(output)
    assert Dir.exist?(cleon_clone)
    assert_equal log, output

    # check if compiles
    home = Home.new(cleon_clone)
    home.source # setting for base, etc.
    Dir.chdir(home.lib) do
      ruby = "require './#{home.source}'; puts '42'"
      out, _ = capture_subprocess_io { system "ruby -e \"#{ruby}\"" }
      assert_match %r{42}, out
    end
  end
end

# TODO: comment after finishing cli_spec and exe_spec
# describe 'Spec' do
#   include SharedClone
#
#   let(:cleon_clone) { 'cleon_clone' }
#
#   it 'must do something' do
#     log = nil
#     # out, _ = capture_subprocess_io do
#       SpecTemp.() do
#         out, _ = capture_io { log = Cleon::Services::CloneCleon.(cleon_clone) }
#         puts log
#         check_result(log)
#       end
#     # end
#   end
# end
