require 'delegate'

module Cleon

  # The Cleon's service metadata
  # @param service [String]
  # @param parameters [Array] @see [Method#parameters]
  MetaService = Struct.new(:name, :parameters)

  # The Cleon's service metadata decorator
  class PortDecor < SimpleDelegator
    def parameters_string
      parameters.map{|(spec, name)|
        case spec
        when :req then "#{name}"
        when :opt then "#{name} = nil"
        when :keyreq then "#{name}:"
        when :key then "#{name}: nil"
        else '&block'
        end
      }.join(', ')
    end

    def arguments_string
      parameters.map{|(spec, name)|
        case spec
        when :req, :opt then "#{name}"
        when :key, :keyreq then "#{name}: #{name}"
        else '&block'
        end
      }.join(', ')
    end

    def parameters_sym_hash
      required = parameters
        .filter{|(spec, _)| spec == :req || spec == :keyreq}
        .map{|(spec, name)| "#{name}: #{name}" }.join(', ')
        .prepend('parameters = {').concat(?})

      optional = parameters
        .reject{|(spec, _)| spec == :req || spec == :keyreq}
        .map{|(spec, name)| "parameters[:#{name}] = #{name} if #{name}"}
        .map{|s| "  #{s}"}
        .join(?\n)

      [required, optional].reject{|s| s.nil? || s.empty?}.join(?\n)
    end

    def parameters_str_hash
      required = parameters
        .filter{|(spec, _)| spec == :req || spec == :keyreq}
        .map{|(spec, name)| "\"#{name}\" => #{name}" }.join(', ')
        .prepend('parameters = {').concat(?})

      optional = parameters
        .reject{|(spec, _)| spec == :req || spec == :keyreq}
        .map{|(spec, name)| "parameters[\"#{name}\"] = #{name} if #{name}"}
        .join(?\n)

      [required, optional].reject{|s| s.nil? || s.empty?}.join(?\n)
    end

    def short_name
      name.split('::').last
    end

    def lib_helper_method_name
      short_name.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end

    def lib_helper_method
      <<~EOF
        # helper for #{name}
        def #{lib_helper_method_name}(#{parameters_string})
          #{parameters_sym_hash}
          #{short_name}.(**parameters)
        end
      EOF
    end

    def api_helper_method_name
      "/" + short_name.gsub(/([a-z\d])([A-Z])/, '\1-\2').downcase
    end

    def api_helper_method
      <<~EOF
        # helper for #{name}
        # #{parameters_string}
        post '#{api_helper_method_name}' do
          #{short_name}Port.(request.body.string, parameters).to_json
        rescue #{name.split('::').first}::Error => e
          {error: e.message}.to_json
        end
      EOF
    end
  end
end
