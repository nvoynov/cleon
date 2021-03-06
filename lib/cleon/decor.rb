require 'delegate'

module Cleon

  # Decorator for model.rb
  class Decor < SimpleDelegator
    attr_reader :root

    def initialize(object, root = '')
      super(object)
      @root = root
    end

    # @return ruby const from @name
    def const
      constanize(name)
    end

    alias :root_const :root

    # def root_const
    #   constanize(root)
    # end

    def source
      "#{sanitize(name)}.rb"
    end

    def spec
      "#{sanitize(name)}_spec.rb"
    end

    def sanitize(str)
      str.downcase.strip.gsub(/\s{1,}/, '_')
    end

    def constanize(str)
      sanitize(str).split(?_).map(&:capitalize).join
    end

    # @return [String] :params presentation as method arguments
    def arguments
      return '' if params.empty?
      params.map(&:name).join(', ')
    end

    # @return [String] :params presentation as method "at" - arguments
    def at_arguments
      return '' if params.empty?
      params.map(&:name).map{|p| "@#{p}"}.join(', ')
    end

    # @return [String] :params presentation as method keywword arguments
    def keyword_arguments
      return '' if params.empty?
      params.map(&:name).join(':, ') + ':'
    end

    def attributes
      retrun '' if params.empty?
      params.map(&:name).map{|a| "attr_reader :#{a}"}.join(?\n) + "\n"
    end
  end

end
