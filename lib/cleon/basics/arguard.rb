module Cleon

  # The factory for guarding argument values
  #
  # @example
  #    # create a new guard for strings
  #    GuardString = ArGuard.new('string', 'must be String'
  #      Proc.new{|v| v.is_a?(String)})
  #
  #    # guarding construtor arguments
  #    class Entity
  #      def initialize(arg)
  #        @arg = GuardString.(arg)
  #        # => ArgumentError: :arg must be String
  #        # @arg = GuardString.(arg, 'name')
  #        # => ArgumentError: :name must be String
  #        # @arg = GuardString.(arg, 'name', 'should be String')
  #        # => ArgumentError: :name should be String
  #      end
  #    end
  #
  class ArGuard
    # @param name [String] name of the guard
    # @param meesage [String] ArgumentError message
    # @param block [Proc] spec of the guard, must return true or false
    # @return [ArGuard]
    def self.new(name, message, block)
      Class.new do
        define_singleton_method "call" do |val, aname = name, amessage = message|
          return val if block.call(val)
          raise ArgumentError, ":#{aname} #{amessage}", caller[0..-1]
        end
      end
    end
  end

end
