# frozen_string_literal: true

require 'simplecov'
# SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cleon"
require "minitest/autorun"

include Cleon

class SpecTemp
  # Execute block inside temp folder
  def self.call
    Dir.mktmpdir(['cleon']) do |dir|
      Dir.chdir(dir) { yield }
    end
  end
end

class SpecCleon
  # execute block inside new Cleon's clone :root
  def self.call(root)
    SpecTemp.() do
      Cleon::Services::CloneCleon.(root)
      Dir.chdir(root) { yield }
    end
  end
end

class SpecCleonExe
  # execute block inside new Cleon's clone :root
  def self.call(root)
    SpecTemp.() do
      Cleon::Services::CloneCleon.(root)
      Dir.chdir(root) {
        # bundler required well formed gemspec
        # does not work!
        File.delete(Home.new.gemspec)
        File.delete("Gemfile")
        # gemfile = File.read("Gemfile")
        # File.write("Gemfile", gemfile + ?\n + 'gem "cleon"')
        # system "bundle update"
        yield
      }
    end
  end
end
