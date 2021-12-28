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
  def self.call(root)
    SpecTmp.() do
      dirs = ['lib', "lib/#{root}"]
      files = ["#{root}.gemspec", "lib/#{root}.rb", "lib/#{root}/version.rb"]
      dirs.each{|dir| Dir.mkdir(dir) }
      files.each{|src| File.write(src, '') }
      yield
    end
  end
end

class SpecGem
  def self.call(root, print_glob = false)
    SpecTmp.() do
      dirs = ['lib',
        "lib/#{root}",
        "lib/#{root}/services",
        "lib/#{root}/entities",
        "test",
        "test/#{root}",
        "test/services",
        "test/entities"
      ]

      files = [
        "#{root}.gemspec",
        "lib/#{root}.rb",
        "lib/#{root}/entities.rb",
        "lib/#{root}/services.rb"
      ]

      dirs.each{|dir| Dir.mkdir(dir) }
      files.each{|src| File.write(src, '')}

      pp Dir.glob('**/*') if print_glob

      yield
    end
  end
end
