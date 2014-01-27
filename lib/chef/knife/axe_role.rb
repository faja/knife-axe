class Chef
  class Knife
    class AxeRole < Chef::Knife
      deps do
        require 'json'
        require 'diffy'
        require 'chef/knife/core/object_loader'
      end

      banner 'knife axe role FILE'

      def run
        if @name_args[0].nil?
          show_usage
          ui.fatal("You must specify a role file")
          exit 1
        end

        loader = Chef::Knife::Core::ObjectLoader.new(Chef::Role, ui)

        @name_args.each do |role_file|
          role_name = File.basename(role_file).split('.')[0]
          role_ff = loader.load_from("roles", role_file)
          role_fc = Chef::Role.load(role_ff.to_hash["name"])

          diff = Diffy::Diff.new(
            JSON.pretty_generate(role_fc.to_hash),
            JSON.pretty_generate(role_ff.to_hash),
            :context => 1)

          if diff.to_s(:text).empty?
            ui.warn("Role #{role_fc.name} has not been changed")
          else
            puts "You are going to update role #{role_fc.name}:"
            puts "\n#{diff.to_s(:color)}\n"

            ui.confirm("Continue")
            role_ff.save
            ui.msg("Saved new version of role #{role_fc.name}")
          end
        end
      end
    end
  end
end
