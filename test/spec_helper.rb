# frozen_string_literal: true

require 'simplecov'
# SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cleon"
require "minitest/autorun"

# jsut inside temp
class SpecTmp
  def self.call
    Dir.mktmpdir(['cleon']) do |dir|
      Dir.chdir(dir) { yield }
    end
  end
end

# just inside gem candidate to clone
class SpecClone
  def self.call(gem)
    SpecTmp.() do
      dirs = ['lib', "lib/#{gem}"]
      files = ["#{gem}.gemspec", "lib/#{gem}.rb", "lib/#{gem}/version.rb"]
      dirs.each{|dir| Dir.mkdir(dir) }
      files.each{|src| File.write(src, '') }
      yield
    end
  end
end

class SpecGem
  def self.call(gem)
    SpecTmp.() do
      dirs = ['lib',
        "lib/#{gem}",
        "lib/#{gem}/services",
        "lib/#{gem}/entities",
        "test",
        "test/#{gem}",
        "test/#{gem}/services",
        "test/#{gem}/entities"
      ]

      files = [
        "#{gem}.gemspec",
        "lib/#{gem}.rb",
        "lib/#{gem}/entities.rb",
        "lib/#{gem}/services.rb"
      ]

      dirs.each{|dir| Dir.mkdir(dir) }
      files.each{|src| File.write(src, '')}

      yield
    end
  end
end
