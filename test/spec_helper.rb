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
