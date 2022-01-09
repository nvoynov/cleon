require_relative 'basics/arguard'
module Cleon

  GuardStringArray = Cleon::ArGuard.new('args', 'must be Array<String>',
    Proc.new {|v| v.is_a?(Array) && v.all?{|v| v.is_a?(String)}})

  class Param
    attr_reader :name
    attr_reader :guard

    def initialize(name)
      @name, @guard = name.split(':')
    end

  end

  class Model
    attr_reader :name
    attr_reader :params

    # @param args [Array<String>] where the first item is model name
    #   and the rest are its attributes
    def initialize(*args)
      @name, *params = GuardStringArray.(*args)
      @params = params.map{|pa| Param.new(pa)}
    end
  end

end
