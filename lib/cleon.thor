#!/usr/bin/env ruby
require 'thor'
require 'cleon'

class CleonCLI < Thor
  def self.exit_on_failure?
    true
  end

  # clone cleon structure to the gem folder at :path
  desc 'clone [PATH]', 'Clones Cleon structure inside PATH'
  def clone(path = Dir.pwd)
    say "Cleon: clone myself..."
    Cleon.clone_cleon(path)
  end

  desc 'service NAME [PARAM PARAM ..]',
       'clone a new Cleon service with NAME and parameters'
  def service(*args)
    say "Cleon: clone service..."
    log = Cleon.clone_service(args.join(' '))
    log.each{|l| puts "- #{l}" }
  end

  desc 'entity NAME [PARAM PARAM ..]',
       'clone a new Cleon entity with NAME and parameters'
  def entity
    say "Cleon: clone entity..."
    Cleon.clone_entity(args.join(' '))
    log.each{|l| puts "- #{l}" }
  end
end

CleonCLI.start
