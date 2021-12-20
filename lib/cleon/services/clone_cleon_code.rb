require 'fileutils'
require_relative "service"

module Cleon
  module Services

    # The service copies Cleon source code into target gem sources,
    #   changing the original Cleon name to the target gem name.
    class CloneCleonCode < Service

      def initialize(clone_to = Dir.pwd)
        @path = File.expand_path(clone_to)
        Cleon.error!("No such directory: #{@path}") unless Dir.exist? @path

        @spec = Dir.chdir(@path) { Dir.glob('*.gemspec').first }
        Cleon.error!("Not gem directory: #{@path}") unless @spec
        @clonelib = File.join(@path, 'lib')

        @base = @spec.sub('.gemspec', '').split(?-).first
        @clonesrc = File.join(@clonelib, "#{@base}.rb")
        @unit = @base.split(?_).map(&:capitalize).join

        @cleonlib = File.join(Cleon.root, 'lib')
      end

      def call
        create_clone_module
        create_structure
        path_and_copy_files
      end

      private

      def create_clone_module
        clone_tt = File.read(File.join(@cleonlib, 'clone.rb.tt'))
        # TODO: patch content @clonesrc when it exist
        if File.exist?(@clonesrc)
          clonebase = File.basename(@clonesrc)
          FileUtils.cp @clonesrc, "#{@clonesrc}~"
          puts "Cleon created new #{clonebase} file"
          puts "Find original file in #{clonebase}~"
        end
        File.write(@clonesrc, clone_tt % {base: @base, clone: @unit})
      end

      def create_structure
        Dir.chdir(File.join(@clonelib, @base)) {
          %w(entities services gateways).each {|dir|
            Dir.mkdir(dir) unless Dir.exist?(dir)
          }
        }
      end

      def path_and_copy_files
        what = Dir.chdir(@cleonlib) { Dir.glob('**/*.rb') }
        what.delete_if{|s| s =~ /(clone_cleon_code|cleon).rb$/}
        what.each do |source|
          content = File.read(File.join(@cleonlib, source))
          clone_content = content
            .gsub("module #{Cleon.name}", "module #{@unit}")
            .gsub("#{Cleon.name}.", "#{@unit}.")
            .gsub("#{Cleon.name}::", "#{@unit}::")
            .gsub("def_delegator :#{Cleon.name}", "def_delegator :#{@unit}")
          target = File.join(@clonelib, source)
          target.gsub!("#{Cleon.base}/", "#{@base}/")
          if source =~ /services.rb$/
            content.gsub!("require_relative \"services/clone_cleon_code\"", '')
          end
          File.write(target, clone_content)
        end
      end
    end

  end
end
