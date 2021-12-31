# frozen_string_literal: true

require_relative "spec_helper"

# hands running exe/cleon specs; not sure it will work for github ruby build
describe 'exe/cleon' do

  SETUP = begin
    system "rake install"
  end

  describe 'dry-run' do

    it 'must provide banner' do
      _, _ = capture_subprocess_io { system "cleon" }
    end

    it 'must provide clone' do
      SpecClone.('temp') do
        _, _ = capture_subprocess_io { system "cleon clone" }
      end
    end

    it 'must provide service' do
      SpecClone.('temp') do
        _, _ = capture_subprocess_io { system "cleon service thing para1 para2" }
      end
    end

    it 'must provide entity'  do
      SpecClone.('temp') do
        _, _ = capture_subprocess_io { system "cleon entity thing para1 para2" }
      end
    end
  end

end
