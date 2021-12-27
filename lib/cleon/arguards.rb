require_relative 'arguard'
require_relative 'model'

module Cleon
  # Place here shared argument guards for the domain
  module ArGuards

    GuardModel = ArGuard.new('model', 'must be Model',
      Proc.new{|v| v.is_a?(Model)})

  end
end
