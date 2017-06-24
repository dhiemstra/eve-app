module EveSDE
  autoload :DataImporter, 'eve-sde/data_importer'

  DEFAULT_CONFIG = {
    download_host:   'https://www.fuzzwork.co.uk/dump',
    archive:         'postgres-latest.dmp.bz2',
    tmp_path:        File.expand_path("../../tmp/eve-sde", __FILE__),
    table_list_file: File.expand_path("../../lib/table-list.yml", __FILE__)
    # table_map_file: File.expand_path("../../lib/table_map.yml", __FILE__),
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
