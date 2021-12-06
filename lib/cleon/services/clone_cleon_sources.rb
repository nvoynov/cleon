require_relative "service"

module Cleon
  module Services

    # The service copies Cleon source code into target gem sources,
    #   changing the original Cleon name to the target gem name.
    class CloneCleonSources < Service

      # The policy check if the agrument is valid gem folder name
      #   it must be a directory
      #   it must have *.gemspec file inside
      PathToClone = Policy.new(
        "clone_path", ":%s must be gem foder",
        ->(path) {
          return false unless Dir.exist?(path)
          return false unless Dir.chdir(path) { Dir.glob('*.gemspec').first }
          true
        }
      )

      def initialize(path_to_clone)
        PathToClone.chk!(path_to_clone)
        @path_to_clone = File.expand_path(path_to_clone)
      end

      def call
        gemfile = Dir.chdir(@path_to_clone) { Dir.glob('*.gemspec').first }
        raise Cleon::Error.new("Few::Words::Gem are not supported"
        ) if gemfile.include?(?-)
        gemfldr = gemfile.gsub(".gemspec", "")
        gemname = gemfile.gsub(".gemspec", "").split(?_).map(&:capitalize).join

        # clone Cleon basic structure
        Dir.chdir(File.join(@path_to_clone, "lib", gemfldr)) do
          Dir.mkdir "entities" unless Dir.exist? "entities"
          Dir.mkdir "services" unless Dir.exist? "services"
          Dir.mkdir "gateways" unless Dir.exist? "gateways"
        end

        # clone Cleon content
        Dir.chdir(Cleon.root) do
          Dir.glob('lib/**/*.rb').each do |source|
            # source "lib/cleon/services/spawn_clone.rb"
            # target "lib/gemname/services/spawn_clone.rb"
            source_content = File.read(source)
            target_content = source_content
              .gsub("module Cleon", "module #{gemname}")
              .gsub("Cleon.", "#{gemname}.")
              .gsub("Cleon::", "#{gemname}::")
            target = File.join(@path_to_clone, source)
            target.gsub!("cleon/", "#{gemfldr}/")
            # special case for <main_gem>.rb
            if source =~ /cleon.rb$/
              target.gsub!(/cleon.rb$/, "#{gemfldr}.rb")
              target_content.gsub!(
                "require_relative \"cleon/",
                "require_relative \"#{gemfldr}/")
            end
            File.write(target, target_content)
          end
        end
      end
    end

  end
end
