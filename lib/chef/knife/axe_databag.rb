class Chef
	class Knife
    class AxeDataBag < Chef::Knife
      deps do
        require 'json'
        require 'diffy'
      end

      banner 'knife axe data bag DATABAG FILENAME'

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
          ui.fatal("you must specify a data bag")
          exit 1
        end

        if @name_args[1].nil?
          show_usage
          ui.fatal("you must specify a item file")
          exit 1
        end

        databag = @name_args[0]
        item_file = @name_args[1]
        item_name = File.basename(item_file).split('.')[0]
        loader = Chef::Knife::Core::ObjectLoader.new(Chef::DataBagItem, ui)

        item_ff = loader.load_from("data_bags", databag, item_file)
        pretty_json_item_ff = JSON.pretty_generate(item_ff.to_hash)

        item_fc = Chef::DataBagItem.load(databag, item_ff.to_hash["id"]).raw_data
        pretty_json_item_fc = JSON.pretty_generate(item_fc.to_hash)

        dbag = Chef::DataBagItem.new
        dbag.data_bag(databag)

        Diffy::Diff.default_format = :color
        puts "You are going to update data bag #{databag}/#{item_name}"
        puts 'Here comes diff:'
        puts Diffy::Diff.new(pretty_json_item_fc, pretty_json_item_ff, :context => 1)

        puts
        yesno
        dbag.raw_data = item_ff
        dbag.save
      end
    end
  end
end
