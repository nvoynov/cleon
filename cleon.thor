#!/usr/bin/env ruby
require 'thor'
require 'cleon'

class CleonCLI < Thor
  def self.exit_on_failure?
    true
  end

  desc "foo", "Prints foo"
  def foo
    puts "foo"
  end

  desc 'service SERVICE PARA1 PARA2', 'Creates <service>.rb and <service_spec.rb>'
  def service(*params)
    # serv = params.shift
    puts("service: #{params.shift}")
    params.each{|para| puts "param: #{para}"}
  end
end

CleonCLI.start
