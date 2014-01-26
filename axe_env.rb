module Axe
  class AxeEnv < Chef::Knife
    deps do
      require 'json'
      require 'diffy'
    end

    banner 'knife axe env FILENAME'

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
        ui.fatal("You must specify a environment file")
        exit 1
      end

      env_file = @name_args[0]
      env_name = File.basename(env_file).split('.')[0]
      loader = Chef::Knife::Core::ObjectLoader.new(Chef::Environment, ui)

      env_ff = loader.load_from("environments", env_file)
      pretty_json_env_ff = JSON.pretty_generate(env_ff.to_hash)

      env_fc = Chef::Environment.load(env_ff.to_hash["name"])
      pretty_json_env_fc = JSON.pretty_generate(env_fc.to_hash)

      Diffy::Diff.default_format = :color
      puts "You are going to update environment #{env_name}"
      puts 'Here comes diff:'
      puts Diffy::Diff.new(pretty_json_env_fc, pretty_json_env_ff, :context => 1)

      puts
      yesno
      env_ff.save

    end

  end
end
