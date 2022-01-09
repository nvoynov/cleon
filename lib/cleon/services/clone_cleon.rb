require 'fileutils'
require_relative 'service'
require_relative '../home'

module Cleon
  module Services

    # The service copies Cleon source code into target gem sources,
    #   changing the original Cleon name to the target gem name.
    class CloneCleon < Service

      # @param name [String] a gem name suitable for 'bundle gem NAME'
      def initialize(name)
        @home = Home.new(name)
      end

      def call
        Cleon.error! "Canceled. Cannot clone to an existing folder" if @home.exist?

        @log = @home.bundle
        generate_sources
        clone_sources
        # end
        @log
      end

      private

      def generate_sources
        dir = File.join(Cleon.root, 'lib', 'tts')
        tts = Dir.chdir(dir) { Dir.glob("*.rb.tt") }
        # all files instead of 'clone.rb.tt' must be placed to 'lib/base'
        # 'clone.rb.tt' must be placed to 'lib'
        target = ->(source) {
          return File.join(@home.lib, @home.source) if source =~ /clone\.rb\.tt/
          File.join(@home.base_dir, source.sub(/\.tt\z/, ''))
        }

        tts.each do |src|
          template = File.join(dir, src)
          body = File.read(template) % {base: @home.base, clone: @home.const}
          dest = target.call(src)
          log_file_name = "lib/#{@home.base}/" + src.sub(/\.tt\z/, '')
          log_file_name = "lib/#{@home.base}.rb" if log_file_name =~ /clone.rb/
          if File.exist?(dest)
            FileUtils.cp dest, "#{dest}~"
            @log << "#{log_file_name}~"
          end
          File.write(dest, body)
          @log << log_file_name
        end
      end

      # replaces Unit
      def clone_sources
        sources = %w(services/service.rb entities/entity.rb)
        Dir.chdir(@home.base_dir) do
          sources.each do |src|
            path = File.join(Cleon.root, 'lib', 'cleon', src)
            orig = File.read(path)
            body = orig.gsub(Cleon.name, @home.const)
            File.write(src, body)
            @log << "lib/#{@home.base}/#{src}"
          end
        end
      end
    end

  end
end
