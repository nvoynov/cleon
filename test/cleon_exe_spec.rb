# frozen_string_literal: true

require_relative "spec_helper"

# hands running exe/cleon specs; not sure it will work for github ruby build
describe 'exe/cleon' do

  SETUP = begin
    system "rake install"
  end

  describe 'dry-run' do

    it 'must provide banner' do
      out, _ = capture_subprocess_io { system "cleon" }
      assert_equal CLI::BANNER, out
    end

    it 'must provide clone' do
      out, _ = capture_subprocess_io do
        SpecTemp.() { system "cleon clone_cleon" }
      end
      # puts out
      assert_match %r{Clone myself to}, out
      assert_match %r{cloned successfully}, out
    end

    it 'must provide guard'  do
      out, _ = capture_subprocess_io do
        puts "\n----\n#{Dir.glob('**/*')}"
        SpecCleonExe.('temp') { system "cleon arguard thing" }
      end
      # puts out
      assert_match %r{Create arguard}, out
      assert_match %r{created successfully}, out
    end

    it 'must provide service' do
      out, _ = capture_subprocess_io do
        SpecCleonExe.('temp') { system "cleon service thing para1 para2:int" }
      end
      # puts out
      assert_match %r{Create service}, out
    end

    it 'must provide entity'  do
      out, _ = capture_subprocess_io do
        SpecCleonExe.('temp') { system "cleon entity thing para1 para2:int" }
      end
      # puts out
      assert_match %r{Create entity}, out
    end

  end

end
