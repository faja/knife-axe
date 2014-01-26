module Axe
  class AxeRole < Chef::Knife
    deps do
      require 'json'
      require 'diffy'
    end

    banner 'knife axe role FILENAME'

    def yesno
      puts "Continue? [y/n]"
      yn = STDIN.gets.chomp()
      if yn == 'y' or yn == 'Y'
        return 0
      elsif yn == 'n' or yn == 'N'
        puts "You chose 'n'. I'm done here."
        exit 0
      else
        yesno
      end
    end

    def run

      if @name_args[0].nil?
        show_usage
        ui.fatal("You must specify a role file")
        exit 1
      end

      role_file = @name_args[0]
      role_name = File.basename(role_file).split('.')[0]
      loader = Chef::Knife::Core::ObjectLoader.new(Chef::Role, ui)

      role_ff = loader.load_from("roles", role_file)
      pretty_json_role_ff = JSON.pretty_generate(role_ff.to_hash)

      role_fc = Chef::Role.load(role_ff.to_hash["name"])
      pretty_json_role_fc = JSON.pretty_generate(role_fc.to_hash)

      Diffy::Diff.default_format = :color
      puts "You are going to update role #{role_name}"
      puts 'Here comes diff:'
      puts Diffy::Diff.new(pretty_json_role_fc, pretty_json_role_ff, :context => 1)

      puts
      yesno
      role_ff.save

    end

  end
end
