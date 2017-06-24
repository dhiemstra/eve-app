module EveApp
  module SDE
    autoload :DataImporter, 'eve_app/sde/data_importer'

    DEFAULT_CONFIG = {
      download_host:   'https://www.fuzzwork.co.uk/dump',
      archive:         'postgres-latest.dmp.bz2',
      tmp_path:        Rails.root.join('tmp', 'eve-sde'),
      table_list_file: EveApp.root.join('lib', 'table-list.yml'),
      table_map_file:  EveApp.root.join('lib', 'table-map.yml'),
    }

    class << self
      def config
        @_config ||= OpenStruct.new(DEFAULT_CONFIG)
      end

      def table_list
        @_table_list ||= YAML::load_file(config.table_list_file)
      end
    end
  end
end
