require 'erb'
require_relative 'decor'

module Cleon

  # Files generator based on Erb
  #
  # @example
  #   Generator.('class Model;  end', erb: '<%= @model %>', path: Dir.pwd,
  #     place_to: 'models/model.rb', require_to: 'models.rb')
  #
  class Generator
    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end

    # @param mod [Model] source model for generator
    # @param erb [String] erb template
    # @param path [String] output filename
    # @param place_to [String] output filename
    # @param require_to [String] file for adding require_relative
    def initialize(model, erb:, path: Dir.pwd, place_to:, require_to: '')
      @model = model
      @erb = erb
      @path = path
      @place_to = place_to
      @require_to = require_to
    end

    def call
      @ren = ERB.new(@erb, trim_mode: '-')
      body = @ren.result(binding)

      Dir.chdir(@path) do
        File.write(@place_to, body)

        return if @require_to.empty?
        require_as = @place_to.split(/\//).tap do |parts|
          other_parts = @require_to.split(/\//)
          parts.shift while parts[0] == other_parts.shift
        end.join(?/).sub(/.rb\z/, '')

        content = File.read(@require_to)
        File.write(@require_to, "#{content}\nrequire_relative '#{require_as}'")
      end
    end

  end

end
