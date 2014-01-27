class Chef
  class Knife
    class AxeEnv < Chef::Knife
      deps do
        require 'json'
        require 'diffy'
        require 'chef/knife/core/object_loader'
      end

      banner 'knife axe env FILENAME'

      def run
        if @name_args[0].nil?
          show_usage
          ui.fatal("You must specify a environment file")
          exit 1
        end

        loader = Chef::Knife::Core::ObjectLoader.new(Chef::Environment, ui)

        @name_args.each do |env_file|
          env_name = File.basename(env_file).split('.')[0]
          env_ff = loader.load_from("environments", env_file)
          env_fc = Chef::Environment.load(env_ff.to_hash["name"])

          diff = Diffy::Diff.new(
            JSON.pretty_generate(env_fc.to_hash),
            JSON.pretty_generate(env_ff.to_hash),
            :context => 1)

          if diff.to_s(:text).empty?
            ui.warn("Environment #{env_fc.name} has not been changed")
          else
            puts "You are going to update environment #{env_name}:"
            puts "\n#{diff.to_s(:color)}\n"

            ui.confirm("Continue")
            env_ff.save
            ui.msg("Saved new version of environment #{env_fc.name}")
          end
        end
      end
    end
  end
end
