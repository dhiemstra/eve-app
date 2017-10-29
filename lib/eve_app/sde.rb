module EveApp
  module SDE
    autoload :DataImporter, 'eve_app/sde/data_importer'
    autoload :Downloader,   'eve_app/sde/downloader'
    autoload :Normalizer,   'eve_app/sde/normalizer'

    DEFAULT_CONFIG = {
      table_prefix:    :eve,
      download_host:   'https://www.fuzzwork.co.uk/dump',
      archive:         'postgres-latest.dmp.bz2',
      tmp_path:        Rails.root.join('tmp', 'eve-sde'),
      table_list_file: EveApp.root.join('lib', 'table-list.yml')
    }
    PREFIXES = %w(agt dgm map trn inv sta industry ram)

    class << self
      def config
        @_config ||= OpenStruct.new(DEFAULT_CONFIG)
      end

      def table_info
        @_table_info ||= YAML::load_file(config.table_list_file)
      end

      def table_list
        @_table_list ||= table_info.keys
      end
    end
  end
end
