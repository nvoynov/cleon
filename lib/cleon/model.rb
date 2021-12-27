require_relative 'arguard'
module Cleon

  GuardStringArray = Cleon::ArGuard.new('args', 'must be Array<String>',
    Proc.new {|v| v.is_a?(Array) && v.all?{|v| v.is_a?(String)}})

  class Model
    attr_reader :name
    attr_reader :params

    # @param args [Array<String>] where the first item is model name
    #   and the rest are its attributes
    def initialize(*args)
      @name, *@params = GuardStringArray.(*args)
    end
  end

end
