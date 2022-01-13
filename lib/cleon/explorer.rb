require_relative 'port_decor'

module Cleon

  # The class for retrieving services from Cleon's gem
  class Explorer

    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end

    def initialize(source)
      @source = source
    end

    # @return [Array<PortDecor>] for services in @source
    def call
      require @source
      const = Module.const_get("#{@source.capitalize}::Services")
      Cleon.error!("The #{const_name} not found") unless const

      services = const.constants.filter{|co| co !~ /Service\z/}
      services.map do |se|
        klass = const.const_get(se)
        param = klass.instance_method(:initialize).parameters
        PortDecor.new(MetaService.new(klass.to_s, param))
      end
    rescue LoadError => e
      Cleon.error!(e.message)
    end

  end
end
