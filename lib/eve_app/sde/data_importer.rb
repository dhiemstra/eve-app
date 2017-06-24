require "sshkit"

module EveApp
  module SDE
    class DataImporter < SSHKit::Backend::Local
      include Downloader
      include Normalizer

      def initialize
        super
        execute :mkdir, '-p', SDE.config.tmp_path
      end

      private

      def db_config
        ActiveRecord::Base.connection_config
      end

      def sql(sql)
        log "[SQL] #{sql}"
        db.execute(sql)
      end

      def db
        ActiveRecord::Base.connection
      end

      def table_list
        @_table_list ||= begin
          whitelist = Array[SDE.config.table_whitelist].flatten.compact.map(&:to_s)
          tables = SDE.table_list
          tables = whitelist.any? ? tables & whitelist : tables
          Hash[tables.map { |name| [name, normalize_table_name(name)] }]
        end
      end

      def normalize_table_name(name)
        (SDE.config.table_prefix.to_s + name.gsub(/^#{SDE::PREFIXES.join('|')}/, '')).underscore
      end
    end
  end
end
