require 'fileutils'
require_relative 'service'
require_relative '../metagem'

module Cleon
  module Services

    # The service copies Cleon source code into target gem sources,
    #   changing the original Cleon name to the target gem name.
    class CloneCleon < Service

      def initialize(path = Dir.pwd)
        path = File.expand_path(path)
        @meta = MetaGem.new(path)
        Cleon.error!("Unknown path #{path}") unless Dir.exist?(path)
        Cleon.error!("Unknown gem: #{path}") unless @meta.gem?
      end

      def call
        create_structure
        generate_sources
        clone_sources
      end

      private

      def create_structure
        dirs = %w(entities services gateways)
        Dir.chdir(@meta.base_dir) do
          dirs.each do |dir|
            next if Dir.exist?(dir)
            Dir.mkdir(dir)
            puts "'#{dir}' directory created"
          end
        end
      end

      def generate_sources
        dir = File.join(Cleon.root, 'lib', 'tts')
        tts = Dir.chdir(dir) { Dir.glob("*.rb.tt") }
        # all files instead of 'clone.rb.tt' must be placed to 'lib/base'
        # 'clone.rb.tt' must be placed to 'lib'
        target = ->(source) {
          return File.join(@meta.lib, @meta.source) if source =~ /clone\.rb\.tt/
          File.join(@meta.base_dir, source.sub(/\.tt\z/, ''))
        }

        Dir.chdir(@meta.lib) do
          tts.each do |src|
            template = File.join(dir, src)
            body = File.read(template) % {base: @meta.base, clone: @meta.const}
            dest = target.call(src)
            if File.exist?(dest)
              FileUtils.cp dest, "#{dest}~"
              puts "Cleon replaced '#{dest}' that was stored as '#{dest}~'"
            end
            File.write(dest, body)
          end
        end
      end

      # replaces Unit
      def clone_sources
        sources = %w(services/service.rb entities/entity.rb gateways/gateway.rb)
        Dir.chdir(@meta.base_dir) do
          sources.each do |src|
            path = File.join(Cleon.root, 'lib', 'cleon', src)
            orig = File.read(path)
            body = orig.gsub(Cleon.name, @meta.const)
            File.write(src, body)
          end
        end
      end
    end

  end
end
