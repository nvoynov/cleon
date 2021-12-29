#!/usr/bin/env ruby
require 'thor'
require 'cleon'

class CleonCLI < Thor
  include Thor::Actions
  namespace :cleon

  def self.exit_on_failure?
    true
  end

  desc 'service NAME [PARAM PARAM ..]',
       'clone Cleon service with NAME and parameters'
  def service(name, *args)
    say "Cleon: clone service..."
    log = Cleon.clone_service(args.unshift(name).join(' '))
    log.each{|l| puts "    created #{l}" }
  end

  desc 'entity NAME [PARAM PARAM ..]',
       'clone Cleon entity with NAME and parameters'
  def entity(name, *args)
    say "Cleon: clone entity..."
    log = Cleon.clone_entity(args.unshift(name).join(' '))
    log.each{|l| puts "    created #{l}" }
  end
end
