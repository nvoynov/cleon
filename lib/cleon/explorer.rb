module Cleon

  # The class for retrieving services from Cleon's gem
  class Explorer
    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end

    def initialize(source)
      @source = source
    end

    def call
      require @source
      const_name = "#{@source.capitalize}::Services"
      const = Module.const_get(const_name)
      Cleon.error!("The #{const_name} not found") unless const

      services = const.constants.filter{|co| co !~ /Service\z/}
      services.map do |se|
        klass = const.const_get(se)
        initz = klass.instance_method(:initialize)
        {
          service: klass.name,
          params: meth_para(initz),
          args: meth_args(initz),
          helper: meth_helper(klass.name)
        }
      end
    rescue LoadError => e
      Cleon.error!(e.message)
    end

    # @param method [Method]
    def meth_para(method)
      method.parameters.map{|(spec, name)|
        case spec
        when :req then "#{name}"
        when :opt then "#{name} = nil"
        when :key then "#{name}: nil"
        when :keyreq then "#{name}:"
        else '&block'
        end
      }.join(', ')
    end

    # @param method [Method]
    def meth_args(method)
      method.parameters.map{|(spec, name)|
        case spec
        when :req, :opt then "#{name}"
        when :key, :keyreq then "#{name}: #{name}"
        else '&block'
        end
      }.join(', ')
    end

    # @param service [String]
    def meth_helper(service)
      src = service.split(/::/).last
      src.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end
  end
end
