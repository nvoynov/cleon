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
      name.downcase.strip.gsub(/\s{1,}/, '_')
        .split(?_).map(&:capitalize).join
    end

    def root_const
      return '' if root.empty?
      root.downcase.strip.gsub(/\s{1,}/, '_')
        .split(?_).map(&:capitalize).join
    end

    # @return [String] :params presentation as method arguments
    def arguments
      params.join(', ')
    end

    # @return [String] :params presentation as method keywword arguments
    def keyword_arguments
      params.join(':, ') + ':'
    end

    def attributes
      params.map{|a| "attr_reader :#{a}"}.join(?\n) + "\n"
    end

    def source_file(suffix = '')
      src = name.downcase.strip.gsub(/\s{1,}/, '_')
      src = "#{src}_#{suffix}" unless suffix.empty?
      src + '.rb'
    end
  end

end
