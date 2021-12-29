# frozen_string_literal: true

require_relative "spec_helper"

# hands running exe/cleon specs; not sure it will work for github ruby build
describe 'exe/cleon' do

  let(:banner) { /-= Cleon =- is a/ }

  describe 'banner' do
    it 'must print banner when exec withot arguments' do
      out, _ = capture_subprocess_io { system "cleon" }
      assert_match banner, out
    end

    it 'must print banner for unknown commands' do
      out, _ = capture_subprocess_io { system "cleon bla-bla-bla" }
      assert_match banner, out
    end
  end

  describe 'cleon clone' do
    it 'must clone cleon' do
      SpecClone.("exe") do
        out, _ = capture_subprocess_io { system "cleon clone" }
        refute_match banner, out
      end
    end
  end

  describe 'cleon service' do
    it 'must clone service' do
      SpecClone.("exe") do
        out, _ = capture_subprocess_io { system "cleon service build src" }
        refute_match banner, out
      end
    end
  end

  describe 'cleon entity' do
    it 'must clone entity' do
      SpecClone.("exe") do
        out, _ = capture_subprocess_io { system "cleon entity user name" }
        refute_match banner, out
      end
    end
  end
end
