class Chef
  class Knife
    class AxeDataBag < Chef::Knife
      deps do
        require 'json'
        require 'diffy'
        require 'chef/knife/core/object_loader'
      end

      banner 'knife axe data bag DATABAG FILENAME'

      def run
        if @name_args[0].nil?
          show_usage
          ui.fatal("You must specify a data bag")
          exit 1
        end

        if @name_args[1].nil?
          show_usage
          ui.fatal("You must specify a item file")
          exit 1
        end

        loader = Chef::Knife::Core::ObjectLoader.new(Chef::DataBagItem, ui)

        databag=@name_args[0]
        item_file=@name_args[1]
        item_name = File.basename(item_file).split('.')[0]
        item_ff = loader.load_from("data_bags", databag, item_file)
        item_fc = Chef::DataBagItem.load(databag, item_ff.to_hash["id"]).raw_data

        dbag = Chef::DataBagItem.new
        dbag.data_bag(databag)

        diff = Diffy::Diff.new(
          JSON.pretty_generate(item_fc.to_hash),
          JSON.pretty_generate(item_ff.to_hash),
          :context => 1)

        if diff.to_s(:text).empty?
          ui.warn("Data bag #{databag}/#{item_name} has not been changed")
        else
          puts "You are going to update data bag #{databag}/#{item_name}:"
          puts "\n#{diff.to_s(:color)}\n"

          ui.confirm("Continue")
          dbag.raw_data = item_ff
          dbag.save
          ui.msg("Saved new version of data bag item #{databag}/#{item_name}")
        end
      end
    end
  end
end
