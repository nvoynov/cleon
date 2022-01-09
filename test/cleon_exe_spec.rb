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
        SpecCleon.('temp') { system "cleon clone_cleon" }
      end
      puts out
    end

    it 'must provide guard'  do
      out, _ = capture_subprocess_io do
        SpecCleon.('temp') { system "cleon guard thing" }
      end
      puts out
    end

    it 'must provide service' do
      out, _ = capture_subprocess_io do
        SpecCleon.('temp') { system "cleon service thing para1 para2:int" }
      end
      puts out
    end

    it 'must provide entity'  do
      out, _ = capture_subprocess_io do
        SpecCleon.('temp') { system "cleon entity thing para1 para2:int" }
      end
      puts out
    end

  end

end
